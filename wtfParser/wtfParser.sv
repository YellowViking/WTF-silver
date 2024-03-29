grammar wtfParser;

imports silver:langutil;
imports scanner;
--imports AST as my_ast; -- fix the problem with captialized letter
imports AST;
{--
 - A statement declaring a variable and its type.
 -}
nonterminal Decl with ast<Decl>;

concrete productions d::Decl
 | te::TypeExpr id::Id ';'  { d.ast = decl(te.ast, name(id)); }
 | te::TypeExpr id::Id '=' src::Expr ';'  { d.ast = declAssignment(te.ast, name(id), src.ast); }
 | 'Matrix' id::Id '=' src::Expr ';'  { d.ast = declAssignment(typeExprMatrix(), name(id), src.ast); }
 | 'Matrix' id::Id '[' r::Expr ',' c::Expr ']' 
            ri::Id ',' ci::Id '=' e::Expr ';'  { d.ast = declMatrix(name(id), r.ast, c.ast, name(ri), name(ci), e.ast); }

{--
 - A concrete expression denoting a type
 -}
nonterminal TypeExpr with ast<TypeExpr>;

concrete productions t::TypeExpr
 | 'Integer'  { t.ast = typeExprInteger(); }
 | 'Float'    { t.ast = typeExprFloat(); }
 | 'Boolean'  { t.ast = typeExprBoolean(); }
 | 'String'   { t.ast = typeExprString(); }
-- | 'Matrix'   { t.ast = typeExprMatrix(); }



nonterminal Expr with ast<Expr>;

concrete productions e::Expr
 |  '(' e1::Expr ')'  { e.ast = e1.ast; }
 |  'if' c::Expr 'then' t::Expr Else e1::Expr  { e.ast = ifthenelse(c.ast, t.ast, e1.ast); }
 |  'let' s::Stmts 'in' e1::Expr 'end'  { e.ast = letExpr(s.ast, e1.ast); }

-- Logical Operations ---------------------

 | l::Expr '&&' r::Expr  { e.ast = and(l.ast, r.ast); }
 | l::Expr '||' r::Expr  { e.ast = or(l.ast, r.ast); }
 | '!' ne::Expr          { e.ast = not(ne.ast); }

-- Relational Operations ------------------------

 | l::Expr op::'==' r::Expr  { e.ast = eq(l.ast, r.ast); }
 | l::Expr op::'!=' r::Expr  { e.ast = neq(l.ast, r.ast); }
 | l::Expr op::'<'  r::Expr  { e.ast = lt(l.ast, r.ast); }
 | l::Expr op::'<=' r::Expr  { e.ast = lte(l.ast, r.ast); }
 | l::Expr op::'>'  r::Expr  { e.ast = gt(l.ast, r.ast); }
 | l::Expr op::'>=' r::Expr  { e.ast = gte(l.ast, r.ast); }

-- Arithmetic Operations ------------------------

 | l::Expr op::'+' r::Expr  { e.ast = add(l.ast, r.ast); }
 | l::Expr op::'-' r::Expr  { e.ast = sub(l.ast, r.ast); }
 | l::Expr op::'*' r::Expr  { e.ast = mul(l.ast, r.ast); }
 | l::Expr op::'/' r::Expr  { e.ast = div(l.ast, r.ast); }

-- Variable reference

 | id::Id  { e.ast = varRef(name(id)); }
 | id::Id '[' r::Expr ',' c::Expr ']'  { e.ast = matrixRef(name(id), r.ast, c.ast); }

-- Literals

 | l::IntegerLiteral  { e.ast = intLit(loc(l.filename, l.line, l.column), l.lexeme); }
 | l::FloatLiteral    { e.ast = floatLit(loc(l.filename, l.line, l.column), l.lexeme); }
 | l::BooleanLiteral  { e.ast = boolLit(loc(l.filename, l.line, l.column), l.lexeme); }
 | l::StringLiteral   { e.ast = stringLit(loc(l.filename, l.line, l.column), l.lexeme); }

-- Function calls
 | fn::Id '(' p::Expr ')' { e.ast = funcCall(name(fn), p.ast); }

{-
 Stmts
-}
-- A possibly empty sequence of statements

nonterminal Stmts with ast<Stmt>;

concrete productions ss::Stmts
 | s::Stmt rest::Stmts  { ss.ast = case rest of
                            stmtNone() -> s.ast
                          | _ -> seq(s.ast, rest.ast)
                          end; }
 (stmtNone) |           { ss.ast = skip(); }


 -- A non-empty statement. (Either semicolon or closing brace terminated)

nonterminal Stmt with ast<Stmt>;

concrete productions s::Stmt
 | um::StmtUnMatched  { s.ast = um.ast; }
 | m::StmtMatched     { s.ast = m.ast; }
 | d::Decl            { s.ast = declStmt(d.ast); }


 -- A matched statement.
 
nonterminal StmtMatched with ast<Stmt>;

concrete productions s::StmtMatched
 | '{' ss::Stmts '}'                                                        { s.ast = block(ss.ast); }
 | id::Id '='  value::Expr ';'                                              { s.ast = assignment(name(id), value.ast); }
 | id::Id '[' row::Expr ',' col::Expr ']' '=' value::Expr ';'               { s.ast = assignmentMatrix(name(id), row.ast, col.ast, value.ast); }
 | ';'                                                                      { s.ast = skip(); }
 | 'print' '(' e::Expr ')' ';'                                              { s.ast = printStmt(e.ast); }
 | 'for' '(' id::Id '=' lower::Expr 'to' upper::Expr ')' body::StmtMatched  { s.ast = for(name(id), lower.ast, upper.ast, body.ast); }

 -- An unmatched statement

nonterminal StmtUnMatched with ast<Stmt>;

concrete productions s::StmtUnMatched 
 | 'if' '(' c::Expr ')' t::Stmt                 { s.ast = ifthen(c.ast, t.ast); }
 | 'if' '(' c::Expr ')' t::StmtMatched 'else' e::StmtUnMatched  { s.ast = ifelse(c.ast, t.ast, e.ast); }
 | 'if' '(' c::Expr ')' t::StmtMatched 'else' e::StmtMatched    { s.ast = ifelse(c.ast, t.ast, e.ast); }
 | 'for' '(' id::Id '=' lower::Expr 'to' upper::Expr ')' body::StmtUnMatched  { s.ast = for(name(id), lower.ast, upper.ast, body.ast); }


function name
Name ::= id::Id
{
  return astName(loc(id.filename, id.line, id.column), id.lexeme);
}

nonterminal Root with ast<Root>, errors;

concrete productions r::Root
 | 'main' '(' ')' '{' s::Stmts '}'  { r.ast = rootStmt(s.ast); }
