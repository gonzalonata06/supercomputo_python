from os import system
system("clear")

birthd = input("Introduce your birthday in whichever formar you prefer YYYYMMDD, or YYYYDDMM, or MMDDYYYY:   ")
count1 = 0

try:
    if birthd.isdigit():
        for digit in birthd:
            count1 += int(digit) 
        while len(str(count1)) > 1:
            count2 = 0
            for digit in str(count1):
                count2 += int(digit)
                count1 = str(count2)
    print('Your day of life is', count2)

except:
    print('You may have entered incorrectly your  day of birth')
