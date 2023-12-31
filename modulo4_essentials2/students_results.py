from os import system, strerror as strerr
system("clear")

class StudentsDataException(Exception):
    pass


class BadLine(StudentsDataException):
    def __init__(self,line_number,line_string):
        super().__init__(self,line_number, line_string)
        self.line_number = line_number
        self.line_string = line_string
    

class FileEmpty(StudentsDataException):
    def __init__self(self):
        super().__init__(self)

    
name = input("Introduce the file's name  ")
line_number = 1

try:
    file = open(name,'rt')
    lines = file.readlines()
    file.close
    if len(lines) == 0:
        raise FileEmpty()
    #file = open(name,'rt')

    line_1 = lines[line_number - 1]
 
    columns = line_1.split()
    
    if len(columns) != 3:
        raise BadLine(counter, line_1)

    try:
        points = float(columns[2])
    except ValueError:
        raise BadLine(counter,line_1)

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
except BadLine as e:
    print("Bad line #" + str(e.line_number) + "with file:" + e.line_string)
except FileEmpty:
    print("Source file empty")

