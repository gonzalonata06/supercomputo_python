from os import system
system("clear")

def validacion(lista):
        for i in range(9):
        	for j in range(9):
        		if lista[i].count(lista[i][j]) > 1:
        			print('Sudoku solution invalid')
        			return 0	

        lista1 = []
        for i in range(9):
        	digit = ''
        	
        	for j in range(9):
        		digit += lista[j][i]
        	lista1.append(digit)


        for i in range(9):
        	for j in range(9):
        		if lista1[i].count(lista1[i][j]) > 1:
        			print('Sudoku solution invalid')
        			return 0

        print('Sudoku solution valid')
        


count = 0
lista = []

while True:
    line = input("Introduce a row of 9 integer numbers without spaces between\n")
    if line.isdigit() and len(line) == 9:
        count += 1
        lista.append(line)

    if count == 9:
        print('Data correctly introduced')
        break

validacion(lista)
	 

