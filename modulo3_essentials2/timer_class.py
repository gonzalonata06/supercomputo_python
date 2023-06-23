from os import system
system("clear")

class Timer:
    def __init__(self,hours = 0, minutes = 0, seconds = 0):
        self.__hours = hours
        self.__minutes = minutes
        self.__seconds = seconds

    def __str__(self):
        if  len(str(self.__seconds)) == 1 and len(str(self.__minutes)) == 1 and len(str(self.__hours)) == 1:
            return f'0{self.__hours}:0{self.__minutes}:0{self.__seconds}'
        elif len(str(self.__seconds)) == 1 and len(str(self.__minutes)) == 1:
            return f'{self.__hours}:0{self.__minutes}:0{self.__seconds}'
        elif len(str(self.__minutes)) == 1 and len(str(self.__hours)) == 1:
            return f'0{self.__hours}:0{self.__minutes}:{self.__seconds}'
        elif len(str(self.__seconds)) == 1 and len(str(self.__hours)) == 1:
            return f'0{self.__hours}:{self.__minutes}:0{self.__seconds}'
        elif len(str(self.__seconds)) == 1:
            return f'{self.__hours}:{self.__minutes}:0{self.__seconds}'
        elif len(str(self.__minutes)) == 1:
            return f'{self.__hours}:0{self.__minutes}:{self.__seconds}'
        elif len(str(self.__hours)) == 1:
            return f'0{self.__hours}:{self.__minutes}:{self.__seconds}'
        else:
            return f'{self.__hours}:{self.__minutes}:{self.__seconds}'

    def next_second(self):
        if self.__seconds >= 59:
            self.__seconds = 0
            self.__minutes += 1
        else:
            self.__seconds += 1
        if self.__minutes > 59 and (self.__seconds == 0 or self.__seconds == 59):
            self.__minutes = 0
            self.__hours += 1
        if self.__hours > 23:
            self.__hours = 0
    

    def prev_second(self):
        if self.__seconds <= 0:
            self.__seconds = 59
            self.__minutes -= 1
        else:
            self.__seconds -= 1

        if self.__minutes < 0 and (self.__seconds == 0 or self.__seconds == 59):
            self.__minutes = 59
            self.__hours -= 1    
        if self.__hours < 0:
            self.__hours = 23
   

timer = Timer(23,59,59 )
print(timer)
timer.next_second()
print(timer)
timer.prev_second()
print(timer)
 



        
