text = input("Write your text  ")
text = text.replace(' ','')

contador = 0
text = text.replace(' ','')
for i in range(len(text)):   
    if text[i].lower() == text[len(text) - 1 - i].lower():
        contador += 1

if contador == len(text):
    print("It's a palindrome")
else: 
    print('Not a palindrome')
print(text)
