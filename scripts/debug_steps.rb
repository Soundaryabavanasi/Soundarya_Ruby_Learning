def greet(name)
  message = "Hello, #{name}!"
  puts message
  return message
end

def main
  user = "Soundarya"
  greet(user)
end

main

## ruby starts from the top of the file where the first method has declared but does not run it yet, 
## it moved to another method where the declared inside a method another method called and we can see the main method is called out so it goes into the method fist
## and check the another mwthod is called and we can see main method has the variable with value so this value will take to greet(user) variable and update the user variable value with name.

## control pannel

