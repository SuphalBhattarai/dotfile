#!/bin/python3
from pyautogui import prompt
import os
import time

ls = os.listdir("/home/suphal/.scripts/")
scripts = " The list of known scripts are : "

for x in ls:
    scripts = scripts + "\n" + "          " + x

script = prompt(text=scripts, title='scripts' , default='form.py')

command = " "

for test in ls:
     if script == test:
         command = "/home/suphal/.scripts/" + script

if command == " ":
    os.system(script)
else:
    os.system(command)

