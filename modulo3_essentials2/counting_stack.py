class Stack:
    def __init__(self):
        self.__stk = []

    def push(self, val):
        self.__stk.append(val)

    def pop(self):
        val = self.__stk[-1]
        del self.__stk[-1]
        return val


class CountingStack(Stack):
    def __init__(self):
    #
    # Fill the constructor with appropriate actions.
    #
        Stack.__init__(self)
        self.__pop_counter = 0

    def get_counter(self):
    #
    # Present the counter's current value to the world.
    #
        return self.__pop_counter
        
    def pop(self):
    #
    # Do pop and update the counter.
        Stack.pop(self) 
        self.__pop_counter += 1


stk = CountingStack()
for i in range(100):
    stk.push(i)
    stk.pop()
print(stk.get_counter())

