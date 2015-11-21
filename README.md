__Fehu__ is
- Functional
- Impure
- Dynamicly typed

# Functions
__Fehu__ uses prefix notation
```
[Add 4 2] -- 6
```

There is also support for partial application of functions
```
Add2 = [Add 2 _]
[Add2 4] -- 6
```

Together with the `into` operator (`>`), partial application
makes it easy to define data flows.
```
[Add 8 [Mult 5 2]] -- 18
[Mult 5 2] > [Add 8 _] -- 18
```

Blanks (`_`) can also be used between `into`s:
```
TimesFivePlusEight = _ > [Mult 5 _] > [Add 8 _]
[TimesFivePlusEight 2] -- 18
```

To define functions, you just bind a lambda expression to a
variable
```
Hello = [ name -> [str "Hello, " name] ]
[Hello "World"] -- "Hello, World"
```

Lambdas may have many clauses, separated by `|`, to pattern match.
```
Greet = [ greeting name -> [str greeting ", " name]
        | name          -> [Greet "Hello" name]
        | #nil          -> [Greet "Hello" "World" ]

[Greet "Hallo" "Welt"] -- "Hallo, Welt"
[Greet "World"] -- "Hello, World"
[Greet #nil] -- "Hello World"
[Greet] -- "Hello, World"
```

Parameters can also be pattern matched agains one-parameter functions
that return booleans. Those are called guards.
```
Check = [ [gt 8 x] -> #passed | _ -> #failed ]

[Check 9] -- #passed
[Check 6] -- #failed
```

# Tags and Tagged values
Tags represent a name and are how booleans are represented in
__Fehu__ (`#t` for true and `#f` for false).

You can tag other values to give them meaning like
`#lang "Fehu"` or `#kilos 3`.

Tags provide cheap and powerful abstractions and are the main
tool for modeling in __Fehu__.

## Enumerations
It's quite common in applications to have to model the
possible states of an object. So an incomplete list of
possible statuses of an order might be: `#placed`, 
`#cleared` and `#shipped`.

Sometime your states may carry some data with the status, 
so when modeling your user you might either expect `#guest`
or `#loggedin "username"`

## Error handling
They also provide a way to reason about error states.
```
-- maybe
#some "value"
#none

-- result
#ok 42
#err "message"
```

## Data Structures
Finally, tags allow you to create data structures.

```
-- list
#item (1 #item 2 (#item 3 #empty))

-- tree
#node 2 (#node 1 #empty #empty) (#node 3 #empty #empty) 
```

__Fehu__ provides some default data structures, so don't
worry, you won't have to build lists like that:
```
-- lists
'[1 2 3]
1 . '[2 3]
1 . 2 . '[3]
1 . 2 . 3 . '[]

-- maps
'{ "a" 1 "b" 2 "c" 3 }
'{ "a" 1 } . '{"b" 2 "c" 3}
```
