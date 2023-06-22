class Timer:


    def __init__(self,hours = 0, minutes = 0, seconds = 0):
        self.__hours = hours
        self.__minutes = minutes
        self.__seconds = seconds

    def __str__(self):


    def next_second(self):
        if self.seconds == 59:
            self.seconds = 0
            self.minutes += 1
        else:
            self.seconds += 1
        
        if self.minutes == 59:
            self.minutes = 0
            self.hours += 1
        else:
            self.minutes += 1
        
        if self.hours = 23:
            self.hours = 0
        else: 
            self.hours += 1
            

    def previous_second(self):
        if self.seconds == 0:
            self.seconds = 59
            self.minutes -= 1
        else:
            self.seconds -= 1

        if self.minutes == 0:
            self.minutes = 59
            self.hours -= 1
        else:
            self.minutes -= 1

        if self.hours = 0:
            self.hours = 23
        else:
            self.hours -= 1


 



        
