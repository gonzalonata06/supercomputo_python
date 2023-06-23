from os import system
system("clear")

class WeekDayError(BaseException):
    pass


class Weeker:
    def __init__(self,day):
        lista = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        if day in lista:
            self.__day = day   
        else:
            raise WeekDayError
    def add_days(self,n):
        lista = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        n_index = lista.index(self.__day) + n % len(lista)
        if n_index > len(lista) - 1:
            n_index -= len(lista) - 1
            self.__day = lista[n_index] 
        else:

            self.__day = lista[lista.index(self.__day) + n % len(lista)]    
        

    def subtract_days(self,n):
        lista = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        n_index = lista.index(self.__day) - n % len(lista)
        if n_index < 0:
            n_index += len(lista)
            self.__day = lista[n_index]
        else:
            self.__day = lista[lista.index(self.__day) - n % len(lista)] 

    def __str__(self):
        return f'{self.__day}'
    
try:
    weekday = Weeker('Mon')
    print(weekday)
    weekday.add_days(15)
    print(weekday)
    weekday.subtract_days(23)
    print(weekday)
    weekday = Weeker('Monday')
except WeekDayError:
    print("Sorry, I can't serve your request.")
    
