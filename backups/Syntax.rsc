module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */

start syntax Form 
  = "form" Id "{" Question* "}"; 

// TODO: question, computed question, block, if-then-else, if-then
syntax Question
  = Str Id ":" Type // Question
  | Str Id ":" Type "=" Expr // computed Question
  | "if" "(" Expr ")" "{" Question* "}" // if question
  | "if" "(" Expr ")" "{" Question* "}" "else" "{" Question* "}" // if-else Question
  ; 

// TODO: +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" \ "if" \ "else" // true/false are reserved keywords.
  | Term (("+" | "-") Term)*
  | left Expr BoolOp Expr
  | "(" Expr ")"
  ;

syntax Term
  = Factor (("*" | "/") Factor)*
  ;
  
syntax Factor
  = Int
  | "(" Expr ")"
  | Id
  ;

syntax Type
  = "boolean"
  | "integer"
  ;  
  
lexical BoolOp
  = "&&" | "||" | "!" | "\>" | "\<" | "\<=" | "\>=" | "==" | "!=";

lexical Str 
  = [\"] ![\"]* [\"];

lexical Int 
  = "-"?[1-9][0-9]*;

lexical Bool 
  = "true"
  | "false"
  ;



