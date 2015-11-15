I'm prototyping **Fehu** in Ruby, so all methods from the `Kernel`
module are available.

```
[puts "Hello, World"]
```

__Fehu__ is a functional language, so let's define a function.
```
greet = [ greeting name -> [str greeting ", " name "!"] ]
[puts [greet "Hello" "World"]]
```
Functions are just bound lambdas. Parameters are separated by
spaces and the body of the lambda should contain one single
expression

Prefix notation can get messy so the `>` operator
(pronounced _into_) is supported.
```
[greet "Hello" "World"] > puts
```
__Fehu__ doesn't support default parameters, but lambdas can
have many cases.
```
greet = [ greeting name -> [str greeting ", " name "!"]
        | name          -> [greet "Hello" name] ]

[greet "World"] > puts
```
That's great, but what if don't agree with the default and want
to change that behaviour? Partial application can help you.
```
greet-pt = [greet "Oi" _]
[greet-pt "Mundo"] > puts
```
Since __Fehu__ isn't a pure functional language, it makes sense
to suport functions that doesn't take any arguments. So to sum
up all the ways you can say hello in __Fehu__
```
greet = [ greeting name -> [str greeting ", " name "!"]
        | name          -> [greeting "Hello" name]
        | !             -> "Hello World" ]

[puts "Hello, World"]
[puts [greet "Hello" "World"]]
[greet "World"] > puts
greet! > puts

greet-pt = [greet "Oi" _]
[greet-pt "Mundo"] > puts
```
