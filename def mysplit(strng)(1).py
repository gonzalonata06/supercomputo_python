def mysplit(strng):
    #
    # put your code here
    #
    lista = []
    word = ''
    strng = strng.lstrip()
    for i in range(len(strng)):
        if strng[i] == ' ':
            lista.append(word)
            word = ''
            continue
        else:
                word = word + strng[i]  
    return lista

print(mysplit("To be or not to be, that is the question"))
print(mysplit("To be or not to be,that is the question"))
print(mysplit("   "))
print(mysplit(" abc "))
print(mysplit(""))
    
