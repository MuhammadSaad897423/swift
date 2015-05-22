// RUN: %target-parse-verify-swift

struct S {
  var x: Int = 0
  let y: Int = 0 // expected-note 4 {{change 'let' to 'var' to make it mutable}}

  init() {}
}

struct T {
  var mutS: S? = nil
  let immS: S? = nil // expected-note 10 {{change 'let' to 'var' to make it mutable}}

  init() {}
}

var mutT: T?
let immT: T? = nil  // expected-note 4 {{change 'let' to 'var' to make it mutable}}

let mutTPayload = mutT!

mutT! = T()
mutT!.mutS = S()
mutT!.mutS! = S()
mutT!.mutS!.x = 0
mutT!.mutS!.y = 0 // expected-error{{cannot assign to 'let' property 'y'}}
mutT!.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}
mutT!.immS! = S() // expected-error{{cannot assign through '!': 'immS' is immutable}}
mutT!.immS!.x = 0 // expected-error{{cannot assign to 'x': 'immS' is immutable}}
mutT!.immS!.y = 0 // expected-error{{cannot assign to 'let' property 'y'}}

immT! = T() // expected-error{{cannot assign through '!': 'immT' is immutable}}
immT!.mutS = S() // expected-error{{cannot assign to 'mutS': 'immT' is immutable}}
immT!.mutS! = S() // expected-error{{cannot assign through '!': 'immT' is immutable}}
immT!.mutS!.x = 0 // expected-error{{cannot assign to 'x': 'immT' is immutable}}
immT!.mutS!.y = 0 // expected-error{{cannot assign to 'let' property 'y'}}
immT!.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}
immT!.immS! = S() // expected-error{{cannot assign through '!': 'immS' is immutable}}
immT!.immS!.x = 0 // expected-error{{cannot assign to 'x': 'immS' is immutable}}
immT!.immS!.y = 0 // expected-error{{cannot assign to 'let' property 'y'}}

var mutIUO: T! = nil
let immIUO: T! = nil // expected-note 2 {{change 'let' to 'var' to make it mutable}}

mutIUO!.mutS = S()
mutIUO!.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}
immIUO!.mutS = S() // expected-error{{cannot assign to 'mutS': 'immIUO' is immutable}}
immIUO!.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}

mutIUO.mutS = S()
mutIUO.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}
immIUO.mutS = S() // expected-error{{cannot assign to 'mutS': 'immIUO' is immutable}}
immIUO.immS = S() // expected-error{{cannot assign to 'let' property 'immS'}}

func foo(x: Int) {}

var nonOptional: S = S()
_ = nonOptional! // expected-error{{operand of postfix '!' should have optional type; type is 'S'}}
_ = nonOptional!.x // expected-error{{operand of postfix '!' should have optional type; type is 'S'}}

class C {}
class D: C {}

let c = C()
let d = (c as! D)! // expected-error{{forced downcast already produces a non-optional value}}
