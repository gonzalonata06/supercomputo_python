from os import system
system("clear")

text1 = input("Introduce the first text  ")
text2 = input("Introduce the second text  ")
text1 = text1.lower()
text2 = text2.lower()


lista1 = []
lista2 = []

for letter in text1:
    cantidad = text1.count(letter)
    lista1.append([letter,cantidad])
    
for letter in text2:
    cantidad = text2.count(letter)
    lista2.append([letter,cantidad])

if sorted(lista1) == sorted(lista2):
    print('Anagrams')
else: 
    print('Not anagrams')


#print(sorted(lista1))
#print(lista2.sort())


# Por qué funcionó sorted(lista1) pero no lista1.sort()
#
#
