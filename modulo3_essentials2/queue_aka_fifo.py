from os import system
system("clear")


class QueueError(IndexError):
    "Raised when the list ran out of elements"
    pass



class Queue:
    def __init__(self):
        self.queue_list = []

    def put(self,element):
        self.queue_list.insert(0,element)

    def get(self):
        if len(self.queue_list) > 0:
            val = self.queue_list[-1]
            del self.queue_list[-1]
            return val
        else:
            raise QueueError


        
        
que = Queue()
que.put(1)
que.put("dog")
que.put(False)

try:
    for i in range(4):
        print(que.get())
except:
     print("Queue error")


    
