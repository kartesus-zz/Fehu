The interpreter is written in ruby.

All functions from `Kernel` is available.
```
[puts "Hello"]
```

If the function isn't defined and is not in `Kernel` it's
interpreted as a method call on the first parameter:
```
[to_i "42" 16] -- same as "42".to_i(16)
```

To run the example
```
./fehu examples/hello.fu
```
