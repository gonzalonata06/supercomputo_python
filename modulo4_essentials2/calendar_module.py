import calendar

class MyCalendar(calendar.Calendar):

    def count_weekday_in_year(self,year,weekday):
        num_days = 0
        for i in range(1,13):
            for data in self.monthdays2calendar(year,i):
                for day in data:
                    if day[1] == weekday and day[0] != 0:
                        num_days += 1
        return num_days



calendario = MyCalendar()
print(calendario.count_weekday_in_year(2019,0))
#type(calendario)
