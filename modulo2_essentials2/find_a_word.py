word = input("Introduce a word  ")
text = input("Introduce a text  ")

word = word.lower()
text = text.lower()
word = word.replace(' ','')
text = text.replace(' ','')


contador = 0
if word.isalpha() and text.isalpha():
    for letter in word:
        if letter in text:
            contador += 1

    if contador == len(word):
        print('Yes')
    else: 
        print('No')
else:
    print('You may have entered a wrong text or word')

