grammar AST;

imports wtfParser;
imports silver:langutil;
{--
 - Type expression ast
 -}

synthesized attribute cppCode :: String
  occurs on Root, Stmt, Decl, Expr, TypeExpr;

nonterminal Name with name;
synthesized attribute name :: String;

abstract production astName
n::Name ::= l::Location s::String
{
  n.name = s;
}
---------------------------------------------------------------------------
-- Root, aspect over the production in Root.sv
abstract production rootStmt
r::Root ::= s::Stmt
{
  r.errors := [];
  r.cppCode = "#include \"Runtime.h\"\n\n" ++
             "int main() {\n " ++
             s.cppCode ++
             "\nreturn 0;\n}\n\n";
}

---------------------------------------------------------------------------
-- Statements, aspects over productions in Stmt.sv
abstract production declStmt
s::Stmt ::= d::Decl 
{
  s.cppCode = d.cppCode;
}

abstract production block
s::Stmt ::= body::Stmt 
{
  s.cppCode = "{\n" ++ body.cppCode ++ "}\n";
}

abstract production seq
s::Stmt ::= s1::Stmt s2::Stmt 
{
  s.cppCode = s1.cppCode ++ s2.cppCode;
}

abstract production printStmt
s::Stmt ::= e::Expr 
{
  s.cppCode = "print (" ++ e.cppCode ++ "); \n";
}

abstract production skip
s::Stmt ::= 
{
  s.cppCode = "";
}

abstract production ifthen
s::Stmt ::= c::Expr t::Stmt 
{
  s.cppCode = "if ( " ++ c.cppCode ++ " )\n" ++ t.cppCode;
}

abstract production ifelse
s::Stmt ::= c::Expr t::Stmt e::Stmt 
{
  s.cppCode = "if ( " ++ c.cppCode ++ " )\n" ++ t.cppCode ++ 
             "else \n" ++ e.cppCode;
}

abstract production assignment
s::Stmt ::= id::Name e::Expr 
{
  s.cppCode = id.name ++ " = " ++ e.cppCode ++ "; \n";
}

abstract production for
s::Stmt ::= i::Name lower::Expr upper::Expr body::Stmt
{ 
  s.cppCode = 
   "for(int " ++ i.name ++ " = " ++ lower.cppCode ++ ";" ++ i.name ++ " <= " ++ upper.cppCode ++ ";" ++ i.name ++ " += 1)" ++ body.cppCode;
}

abstract production assignmentMatrix
s::Stmt ::= id::Name r::Expr c::Expr e::Expr 
{
  s.cppCode = id.name ++ "[Index2D(" ++ r.cppCode ++ ", " ++ c.cppCode ++ ")] = " ++ e.cppCode ++ ";\n";
}

abstract production matrixRef
e::Expr ::= id::Name r::Expr c::Expr
{
  e.cppCode = id.name ++ "[Index2D(" ++ r.cppCode ++ "," ++ c.cppCode ++ ")]";
}
---------------------------------------------------------------------------
-- Declarations and Type Expressions, aspects over productions in Decl.sv
abstract production decl
d::Decl ::= t::TypeExpr id::Name 
{
  d.cppCode = t.cppCode ++ " " ++ id.name ++ "; \n";
}

abstract production declMatrix
d::Decl ::= id::Name r::Expr c::Expr ri::Name ci::Name v::Expr
{
  d.cppCode = 
   "Matrix<Float> " ++ id.name ++ "(" ++ r.cppCode ++ "," ++ c.cppCode ++ ");\n" ++
   "for(int " ++ ri.name ++ " = 0; " ++ ri.name ++ " < " ++ r.cppCode ++ "; " ++ ri.name ++ "++) {\n" ++
   " for(int " ++ ci.name ++ " = 0; " ++ ci.name ++ " < " ++ c.cppCode ++ "; " ++ ci.name ++ "++) {\n" ++
   "  " ++ id.name ++ "[Index2D(" ++ ri.name ++ "," ++ ci.name ++ ")] = " ++ v.cppCode ++ ";\n" ++
   " }\n" ++
   "}\n";
}
abstract production declAssignment
d::Decl ::= te::TypeExpr id::Name src::Expr
{
  d.cppCode = te.cppCode ++ " " ++ id.name ++ " = " ++ src.cppCode ++ "; \n";
}

abstract production typeExprInteger
t::TypeExpr ::=  
{
  t.cppCode = "Integer";
}
abstract production typeExprFloat
t::TypeExpr ::=  
{
  t.cppCode = "Float";
}
abstract production typeExprBoolean
t::TypeExpr ::=  
{
  t.cppCode = "Boolean";
}
abstract production typeExprString
t::TypeExpr ::=  
{
  t.cppCode = "String";
}

abstract production typeExprMatrix
t::TypeExpr ::=  
{
  t.cppCode = "Matrix<Float>";
}

---------------------------------------------------------------------------
{- Expressions, aspects over productions in Expr.sv

Note that we do not define the cppCode attribute for those relational
and logical operations that (umm that WHAT? hahahaha)
-}
abstract production funcCall
e::Expr ::= fn::Name p::Expr
{
  e.cppCode = fn.name ++ " (" ++ p.cppCode ++ ")";
}

abstract production ifthenelse
e::Expr ::= c::Expr t::Expr e1::Expr
{
  e.cppCode = "(" ++ c.cppCode ++ " ? " ++ t.cppCode ++ " : " ++ e1.cppCode ++ ")";
}

abstract production letExpr
e::Expr ::= s::Stmt e1::Expr
{
  e.cppCode = "({" ++ s.cppCode ++ e1.cppCode ++ ";})";
}

abstract production intLit
e::Expr ::= l::Location s::String
{
  e.cppCode = s;
}
abstract production floatLit
e::Expr ::= l::Location s::String
{
  e.cppCode = s;
}
abstract production boolLit
e::Expr ::= l::Location s::String
{
  e.cppCode = s;
}
abstract production stringLit
e::Expr ::= l::Location s::String
{
  e.cppCode = "(String)" ++ s;
}

abstract production varRef
e::Expr ::= id::Name
{
  e.cppCode = id.name;  
}

abstract production add
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " + " ++ r.cppCode ++ ")";  
}
abstract production sub
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " - " ++ r.cppCode ++ ")";  
}
abstract production mul
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " * " ++ r.cppCode ++ ")";  
}
abstract production div
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " / " ++ r.cppCode ++ ")";  
}

abstract production eq
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " == " ++ r.cppCode ++ ")";  
}
abstract production lt
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " < " ++ r.cppCode ++ ")";  
}

abstract production and
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " && " ++ r.cppCode ++ ")";  
}

abstract production not
e::Expr ::= ne::Expr 
{
  e.cppCode = "( !" ++  ne.cppCode ++ ")";  
}

{-
  composed operators.
-}
abstract production neq 
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " != " ++ r.cppCode ++ ")"; 
  forwards to not (eq(l,r));
}

abstract production lte 
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " <= " ++ r.cppCode ++ ")"; 
  forwards to or( lt(l,r), eq(l,r) );
}
abstract production gt 
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " > " ++ r.cppCode ++ ")"; 
  forwards to not(lte(l,r));
}
abstract production gte 
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " >= " ++ r.cppCode ++ ")"; 
  forwards to not(lt(l,r));
}

abstract production or 
e::Expr ::= l::Expr r::Expr 
{
  e.cppCode = "(" ++  l.cppCode ++ " || " ++ r.cppCode ++ ")";
  forwards to not( and(not(l), not(r)) );
}



