import os

class DirectorySearch:
    def find(self,path, dir):
        try:
            os.chdir(path)
        except OSError:
            return

        current_dir = os.getcwd()
        for direc in os.listdir("."):
            if direc == dir:
                print(os.getcwd()+ "\\" + dir)
            self.find(current_dir + "\\" + direc, dir)

os.chdir("C:\\Users\\Gonzalo\\AppData\\Local\\Programs\\Python\\Python311")
search_python = DirectorySearch()
search_python.find("tree","python")
