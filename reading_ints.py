def read_int(prompt, min, max):
    #
    # Write your code here.
    #
    while True:
        
        try:
            number = input(prompt)
            assert int(number) <= max and int(number) >= min
            return number
            
                 
            
        except AssertionError:
            print(number,'is not in the range')
        except ValueError:
            print(number, 'is not an integer number')
            

v = read_int("Enter a integer number from -10 to 10: ", -10, 10)

print("The number is:", v)
