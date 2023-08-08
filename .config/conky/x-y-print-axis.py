import pyautogui
import os

while True:
    x, y = pyautogui.position()
    os.system("clear||cls")
    print(x, y)

# prints x nd y axis on terminal
# alternative linux cmd 'xdotool getmouselocation'
