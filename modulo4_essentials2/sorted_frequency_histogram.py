from os import system, strerror as strerr
system("clear")

name  = input("Ingresa la ruta del archivo    ")

try:
    histogram = {}
    file = open(name, 'rt')
    char = file.read(1).lower()

    while char != '':
        if char in histogram.keys() and char.isalpha():
            histogram[char] += 1
        elif char.isalpha():
            histogram[char] = 1
        
        char = file.read(1).lower()
    file.close()

    
    file_out = open(name+".hist", "wt")
    histogram = dict(sorted(histogram.items(), key=lambda x:x[1], reverse=True))
    print(histogram)
    for key in histogram.keys():
        s = key + '->' + str(histogram[key]) + '\n'
        for char in s:
            file_out.write(char)
            
        print(key,'->' ,histogram[key])
    file_out.close()
    
except IOError as e:
    print("I/O error occurred: ", strerr(e.errno))




