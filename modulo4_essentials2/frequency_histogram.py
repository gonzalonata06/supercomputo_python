from os import system, strerror as strerr
system("clear")

name  = input("Ingresa la ruta del archivo    ")

try:
    histogram = {}
    file = open(name, 'rt')
    content = file.read()
    for char in content:
        char = char.lower()
        if char in histogram.keys() and char.isalpha():
            histogram[char] += 1
        elif char.isalpha():
            histogram[char] = 1
        
    file.close()
except IOError as e:
    print("I/O error occurred: ", strerr(e.errno))
    
for key in histogram.keys():

    print(key,'->' ,histogram[key])


