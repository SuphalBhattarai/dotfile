#! /usr/bin/python
import os
import pyautogui
os.system("killall zoom")
os.system("zoom &")

# Holds down the alt key
pyautogui.keyDown("winleft")

# Presses the tab key once
pyautogui.keyDown("6")

pyautogui.keyUp("6")
# Lets go of the alt key
pyautogui.keyUp("winleft")
os.system("sleep 10")

# pyautogui.moveTo(100, 100, duration=0.25)
# pyautogui.moveTo(200, 100, duration=0.25)
# pyautogui.moveTo(200, 200, duration=0.25)
# pyautogui.moveTo(100, 200, duration=0.25)
pyautogui.click(1200,300,duration=0.25)
pyautogui.click(700, 310, duration=0.25)
pyautogui.typewrite("")
pyautogui.click(750,520,duration=0.25)
os.system("sleep 2")
pyautogui.click(900,460,duration=0.25)
pyautogui.typewrite("1234")
pyautogui.click(700,520,duration=0.25)
