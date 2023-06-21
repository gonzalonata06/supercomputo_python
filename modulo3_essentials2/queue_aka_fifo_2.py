from os import system
system("clear")

class QueueError(IndexError):
    #"Raised when the list ran out of elements"
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

class SuperQueue(Queue):
    def isempty(self):
        if len(self.queue_list) == 0:
            return True
        else:
            return False

que = SuperQueue()
que.put(1)
que.put("dog")
que.put(False)
for i in range(4):
    if not que.isempty():
        print(que.get())
    else:
        print("Queue empty")
