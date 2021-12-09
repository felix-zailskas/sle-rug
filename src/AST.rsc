module AST

/*
 * Abstract Syntax for QL
 *
 * The abstract syntax abstracts away from the literal syntax of the language.
 * Keywords are not needed and stored anymore, instead the logical meaning of
 * them is kept and stored in the abstract representations of the syntax's cases.
 * 
 * Each item of the syntax is almost mapped one to one to its abstract counterpart.
 */

// A form has an ID and a list of questions.
data AForm(loc src = |tmp:///|)
  = form(AId id, list[AQuestion] questions)
  ; 

// Each question type is represented by a different constructor.
data AQuestion(loc src = |tmp:///|)
  = question(str text, AId id, AType atype)
  | computed(str text, AId id, AType atype, AExpr expr)
  | ifconditional(AExpr cond, list[AQuestion] questions)
  | elseconditional(AExpr cond, list[AQuestion] questions, list[AQuestion] options)
  | block(list[AQuestion] questions)
  ; 

// Each expression type is represented by a different constructor.
// I decided to create a separate constructor for each binary relational
// operator.
data AExpr(loc src = |tmp:///|)
  = ref(AId id)
  | literal(AType lit)
  | not(AExpr a)
  | mul(AExpr a, AExpr b)
  | div(AExpr a, AExpr b)
  | add(AExpr a, AExpr b)
  | sub(AExpr a, AExpr b)
  | lt(AExpr a, AExpr b)
  | le(AExpr a, AExpr b)
  | gt(AExpr a, AExpr b)
  | ge(AExpr a, AExpr b)
  | eq(AExpr a, AExpr b)
  | neq(AExpr a, AExpr b)
  | and(AExpr a, AExpr b)
  | or(AExpr a, AExpr b)
  ;

// IDs are used to store the name of identifiers and append them with a source location.
data AId(loc src = |tmp:///|)
  = id(str name);

// The types of literals can be string, integer or boolean.
data AType(loc src = |tmp:///|)
  = string()
  | integer()
  | boolean()
  ;
