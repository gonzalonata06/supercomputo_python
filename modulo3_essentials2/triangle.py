from os import system
system("clear")

from math import hypot

class Point:
    def __init__(self,x = 0.0,y = 0.0):
        self.x = x
        self.y = y

    def getx(self):
        print(self.x)

    def gety(self):
        print(self.y)
    def distance_from_xy(self,x,y):
        return hypot(self.x-x,self.y-y)
    def distance_from_point(self,point):
        return hypot(self.x-point.x,self.y-point.y)

class Triangle:
    def __init__(self,point1,point2,point3):
        self.__lista = [point1, point2, point3]

    def perimeter(self):
        suma = 0
        for i in range(len(self.__lista)):
            if i == 2:
                suma += self.__lista[2].distance_from_point(self.__lista[0])
            else:
                suma += self.__lista[i].distance_from_point(self.__lista[i+1])
        return suma
    
triangle = Triangle(Point(0, 0), Point(1, 0), Point(0, 1))
print(triangle.perimeter())
