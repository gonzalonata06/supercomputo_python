from os import system, strerror as strerr
system("clear")

class StudentsDataException(Exception):
    pass


class BadLine(StudentsDataException):
    # Write your code here.
    pass

class FileEmpty(StudentsDataException):
    # Write your code here.
    pass
name = input("Introduce the file's name  ")

try:
    file = open(name,'rt')
    line = file.readline()
    lista = []
    while line != '':
        name = ''
        l_name = ''
        counter = 0
        score = ''
        for char in line:
            if char == ' ':
                counter += 1
            if counter == 0:
                name += char
            elif counter == 1:
                l_name += char
            elif counter == 2 and (char.isdigit() or char == '.'):
                score += char
                
        if [name,l_name] in lista:
            (lista[lista.index([name,l_name]) + 1]) += float(score)
        else:
            lista.append([name,l_name])    
            lista.append(float(score))
        line = file.readline()
        
    file.close()
    
    for i in range(0,len(lista),2):
        print(lista[i][0],lista[i][1],lista[i+1])
    
       

except IOError as e:
    print("I/O error occurred: ", strerr(e.errno))

