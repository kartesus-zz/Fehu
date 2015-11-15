Tags are the basis for data structures in __Fehu__.
```
-- boolean
:t 
:f

-- list
(:cons 1 (:cons 2 (:cons 3 :emtpy)))

-- option
:some "value"
:none

-- result
:ok 42
:error "something went wrong"
```

Tags can be pattern-matched
```
map = [ f :empty       -> :empty
      | f (:cons x xs) -> :cons [f x] [map f xs] ]
```
