module Resolve

import AST;

/*
 * Name resolution for QL
 *
 * This module is used to create a mapping between uses and definitions of identifiers. 
 * It is used to enable the 'jump to declaration' in the rascal IDE.
 */ 


// modeling declaring occurrences of names
alias Def = rel[str name, loc def];

// modeling use occurrences of names
alias Use = rel[loc use, str name];

// modeling map between declaring and use occurences
alias UseDef = rel[loc use, loc def];

// the reference graph
alias RefGraph = tuple[
  Use uses, 
  Def defs, 
  UseDef useDef
]; 

// Creates a reference graph from an AForm.
RefGraph resolve(AForm f) = <us, ds, us o ds>
  when Use us := uses(f), Def ds := defs(f);

// Finds all uses of identifiers in the AForm.
// All uses of identifiers can be found in ref() objects.
Use uses(AForm f) {
  return {<i.src, i.name> | /ref(AId i) := f}; 
}

// Finds all definitions of identifiers in the AForm
// All definitions of identifiers are either simple questions or computed questions.
Def defs(AForm f) {
  return {<i.name, q.src> | /q:question(str _, AId i, AType _) := f}
  		+ {<i.name, c.src> | /c:computed(str _, AId i, AType _, AExpr _) := f}; 
}