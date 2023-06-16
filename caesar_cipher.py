# Caesar cipher.
text = input("Enter your message: ")
var = True


while var:
    try:
        num = int(input("Enter an integer number between 1 and 25 inclusive:  "))
        if num <= 25 and num >= 1 and type(num) == int:
            var = False
            cipher = ''
            #print(text)
            for char in text:
                #print(char)
                if not char.isalpha():
                    cipher += char
                    continue
                #char = char.upper()
                code = ord(char) + num
                if char.isupper() and code - ord('Z'):
                    code = ord('A') + (code - ord('Z')) - 1
                elif char.islower() and code - ord('z') > 0:
                    code = ord('a') + (code - ord('z')) - 1
                    #print(char)
                    #print(chr(code))
                cipher += chr(code)
                #print(chr(code))

           
            print(cipher)
        
        else:
            print("invalid number")
        
    except:
        print("invalid number")
    
    


    
