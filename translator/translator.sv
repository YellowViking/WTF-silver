grammar translator;


{-
@ref 8.3 Creating a parser from a set of grammar
-}

import silver:langutil;
import silver:langutil:pp;
import wtfParser;
import AST;

parser parse :: Root {
  wtfParser;
  scanner;
} 

function main 
IOVal<Integer> ::= largs::[String] io_in::IO
{
  local attribute args :: String;
  args = implode(" ", largs);
  
  production attribute isF :: IOVal<Boolean>;
  isF = isFile(head(largs), io_in);

  production attribute dsl :: IOVal<String>;
  dsl = readFile(head(largs), isF.io);

  production attribute cppFilename :: String;
  cppFilename = head(largs) ++ ".cpp";

  local attribute parseResult :: ParseResult<wtfParser:Root>;
  parseResult = parse(dsl.iovalue, head(largs));

  local attribute parseTree :: wtfParser:Root;
  parseTree = parseResult.parseTree;

  local attribute myAst :: wtfParser:Root;
  myAst = parseTree.ast;

  local attribute print_success :: IO;
  print_success = 
    print( "Command line arguments: " ++ args ++ "\n" ++ 
           (if null(myAst.errors)  then cppFilename ++ " generated!\n" 
            else "\n" ++
                 implode("", ppMessages(myAst.errors)) ++ "\n"
           )
           , dsl.io );

  local attribute write_success :: IO;
  write_success =
    writeFile ( cppFilename, myAst.AST:cppCode, print_success );

  local attribute print_failure :: IO;
  print_failure =
    print("Encountered a parse error:\n" ++ parseResult.parseErrors ++ "\n", dsl.io);

  local attribute ioResult :: IO;
  ioResult =
         if   ! isF.iovalue 
         then error ("\n\nFile \"" ++ args ++ "\" not found.\n")
         else
         if   parseResult.parseSuccess 
         then write_success 
         else print_failure;
  return ioval(ioResult, 0);
}

