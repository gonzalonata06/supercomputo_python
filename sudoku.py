from os import system
system("clear")

contador = 0
lista = []

while True:
    line = input("Introduce a row of 9 integer numbers without spaces between")
    if line.isdigit() and len(line) == 9:
        contador += 1
        lista.append(line)

    if contador == 9:
        break



print('Data correctly introduced')
print(lista)

