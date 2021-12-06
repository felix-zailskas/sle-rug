module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */

start syntax Form 
  = @Foldable "form" Id "{" Question* "}"; 

// TODO: question, computed question, block, if-then-else, if-then
syntax Question
  = Str Id ":" Type // Question
  | Str Id ":" Type "=" Expr // computed Question
  | IfPart ElsePart?
  ;

syntax IfPart
  = @Foldable "if" "(" Expr ")" "{" Question* "}" // if question
  ;

syntax ElsePart
  = @Foldable "else" "{" Question* "}" // if-else Question 
  ;

// TODO: +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" \ "if" \ "else" // true/false are reserved keywords.
  | Str \ "true" \ "false" \ "if" \ "else"
  | Int
  | Bool
  | left Expr "||" Expr
  > left Expr "&&" Expr
  > left Expr ("==" | "!=") Expr
  > left Expr ("\>" | "\>=" | "\<" | "\<=") Expr
  > left Expr ("+" | "-") Expr
  > left Expr ("*" | "/") Expr
  > left "!" Expr
  | "(" Expr ")"
  ;

syntax Type
  = "boolean"
  | "integer"
  | "string"
  ;

lexical Str 
  = [\"] ![\"]* [\"];

lexical Int 
  = [\-]?[1-9][0-9]*
  | [0]
  ;

lexical Bool 
  = "true"
  | "false"
  ;



