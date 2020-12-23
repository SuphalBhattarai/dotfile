#!/usr/bin/python3

import json
from os import system, popen
from time import sleep

from pyautogui import press, write


def kill_zoom():
    system("killall zoom")
    print("killed zoom process")
    sleep(2)


def press_tab(i):
    for _ in range(i):
        sleep(0.5)
        press("tab")


def getIdPassword():
    print("Opening File")
    with open("/home/suphal/Data/zoom.json") as f:
        data = json.loads(f.read())
        meeting_id = data["id"]
        print("Got the id")
        password = data["passcode"]
        print("Got the passcode")
        return meeting_id, password


def main():
    p = popen("pgrep zoom").read()
    if len(p) > 3:
        kill_zoom()
    system("/usr/bin/zoom &")
    print("launched zoom")
    meeting_id, password = getIdPassword()
    sleep(10)
    system("wmctrl -a 'Zoom - Free Account'")
    press_tab(9)
    press("return")
    press_tab(2)
    print("Entering id")
    write(meeting_id)
    press("return")
    sleep(2)
    try:
        p = popen("wmctrl -l | grep -i leave").read()
        if p > 2:
            press("escape")
            sleep(2)
    except:
        pass
    print("Entering passcode")
    write(password)
    press("return")


if __name__ == "__main__":
    main()
