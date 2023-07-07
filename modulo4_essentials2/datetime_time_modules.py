from datetime import datetime
dt = datetime(2020, 11, 4, 14, 53)
print(dt.strftime("%Y/%m/%d %H:%M:%S"))
print(dt.strftime("%Y/%B/%d %H:%M:%S %p"))
print(dt.strftime("%a, %Y %b %d"))
print(dt.strftime("%A, %Y %B %d"))
print(dt.strftime("Weekday: %w"))
print(dt.strftime("Day of the year: %j"))
print(dt.strftime("Week of the year %U"))