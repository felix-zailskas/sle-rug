module CST2AST

import Syntax;
import AST;

import ParseTree;
import String;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 *
 * The functions defined in this file take a concrete syntax tree and transform it into
 * an abstract syntax tree. The abstract syntax defined in the AST module are used for that.
 * Each abstract object is appended its source location, so that it can be found in the source
 * file. This source location is also used to enable the 'jump to declaration' feature in the
 * rascal IDE.
 */

// This function is used to unquote question strings.
str unquote(str s) = s[1..-1];

// Transforms the start symbol of a Form to an AForm.
AForm cst2ast(start[Form] sf) {
  return cst2ast(sf.top);
}

// Transforms a Form to an AForm.
// There is only one way a form is represented.
AForm cst2ast(f:(Form)`form <Id i> { <Question* q> }`) 
	= form(id("<i>", src=i@\loc), [cst2ast(q_) | Question q_ <- q], src=f@\loc);

// Transforms a Question to an AQuestion. 
// Each representation of a Question is handled in the switch statement by using concrete matching.
AQuestion cst2ast(Question q) {
  switch(q) {
    case (Question)`<Str s> <Id i> : <Type t>`: 
      return question(unquote("<s>"), id("<i>", src=i@\loc), cst2ast(t), src=q@\loc);
    case (Question)`<Str s> <Id i> : <Type t> = <Expr e>`: 
      return computed(unquote("<s>"), id("<i>", src=i@\loc), cst2ast(t), cst2ast(e), src=q@\loc);
    case (Question)`if ( <Expr condition> ) { <Question* qs> }`: 
      return ifconditional(cst2ast(condition), [cst2ast(q_) | Question q_ <- qs], src=q@\loc);
    case (Question)`if ( <Expr condition> ) { <Question* qsi> } else { <Question* qse> }`:
      return elseconditional(cst2ast(condition), [cst2ast(q_) | Question q_ <- qsi], [cst2ast(q_) | Question q_ <- qse], src=q@\loc);
    case (Question)`{ <Question* qs> }`:
      return block([cst2ast(q_) | Question q_ <- qs], src=q@\loc);
    default: throw "Unhandled question: <q>";
  }
  
}

// Transforms a Expr to an AExpr. 
// Each representation of a Expr is handled in the switch statement by using concrete matching.
AExpr cst2ast(Expr e) {
  switch (e) {
    case (Expr)`<Id x>`: return ref(id("<x>", src=x@\loc), src=e@\loc);
    case (Expr)`<Str s>`: return literal(string(src=s@\loc));
    case (Expr)`<Int n>`: return literal(integer(src=n@\loc));
    case (Expr)`<Bool b>`: return literal(boolean(src=b@\loc));
    case (Expr)`! <Expr a>`: return not(cst2ast(a), src=e@\loc);
    case (Expr)`<Expr a> * <Expr b>`: return mul(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> / <Expr b>`: return div(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> + <Expr b>`: return add(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> - <Expr b>`: return sub(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> \> <Expr b>`: return gt(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> \>= <Expr b>`: return ge(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> \< <Expr b>`: return lt(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> \<= <Expr b>`: return le(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> == <Expr b>`: return eq(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> != <Expr b>`: return neq(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> && <Expr b>`: return and(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`<Expr a> || <Expr b>`: return or(cst2ast(a), cst2ast(b), src=e@\loc);
    case (Expr)`( <Expr a> )`: return cst2ast(a);
    default: throw "Unhandled expression: <e>";
  }
}

// Transforms a Type to an AType. 
// Each representation of a Type is handled in the switch statement by using concrete matching.
AType cst2ast(Type t) {
  switch(t) {
    case (Type)`boolean`: return boolean(src=t@\loc);
    case (Type)`string`: return string(src=t@\loc);
    case (Type)`integer`: return integer(src=t@\loc);
    default: throw "Unhandled type: <t>";
  }
}
