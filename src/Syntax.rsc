module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */

// Forms are a collection of questions bound to an identifier.
start syntax Form 
  = @Foldable "form" Id "{" Question* "}"; 

// A question is a String bound to an identifier.
// Every question has a data type associated with it.
// Expressions can be assigned to the question's identifier
// and they can also be enclosed in code blocks.
// Furthermore, the display of questions can be declared
// conditionally in if-else statements.
syntax Question
  = Str Id ":" Type // Question
  | Str Id ":" Type "=" Expr // computed Question
  | @Foldable "{" Question* "}" // block
  | IfPart ElsePart? // if and if-else
  ;

syntax IfPart
  = @Foldable "if" "(" Expr ")" "{" Question* "}"
  ;

syntax ElsePart
  = @Foldable "else" "{" Question* "}"
  ;

// Operator precedence defined the following way (source: https://en.cppreference.com/w/c/language/operator_precedence)
// ! > (*, /) > (+, -) > (>, >=, <, <=) > (==, !=), > && > ||
// All operators are left associative.
// Expressions can be enclosed in brackets to nest them.
// The literals of an Expression can be: Identifiers, Strings, Integers or Booleans.
syntax Expr 
  = Id \ "true" \ "false" \ "if" \ "else" // true/false/if/else are reserved keywords.
  | Str
  | Int
  | Bool
  | left "!" Expr
  > left Expr ("*" | "/") Expr
  > left Expr ("+" | "-") Expr
  > left Expr ("\>" | "\>=" | "\<" | "\<=") Expr
  > left Expr ("==" | "!=") Expr
  > left Expr "&&" Expr
  > left Expr "||" Expr
  | bracket "(" Expr ")"
  ;

// Data types are Strings, Integers, Booleans
syntax Type
  = "boolean"
  | "integer"
  | "string"
  ;

// A string is anything enclosed in ""
lexical Str 
  = [\"] ![\"]* [\"];

// Integers can be positive, negative or zero
lexical Int 
  = [\-]?[1-9][0-9]*
  | [0]
  ;

// A boolean is true or false
lexical Bool 
  = "true"
  | "false"
  ;
