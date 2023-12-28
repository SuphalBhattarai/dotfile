#!/usr/bin/env ipython

from re import match
from fpdf import FPDF
import os
import cv2
from rofi import Rofi
from datetime import date
import email_list

documents = "/home/suphal/Documents/"
downloads = "/home/suphal/Downloads/"


def insert_img(x):
    global downloads
    image_location = downloads + x
    img = cv2.imread(image_location)
    i, j, k = img.shape
    if i < j:
        rotated = cv2.rotate(img, cv2.ROTATE_90_CLOCKWISE)
        cv2.imwrite(image_location, rotated)
    pdf.image(image_location, x=0, y=0, w=8.27, h=11.69)


ls = os.listdir(downloads)
pdf = FPDF("P", "in", "A4")
pdf.add_page()
pdf.set_font("Arial", "B", 32)
pdf.set_author("Suphal Bhattarai")
pdf.set_creator("Suphal Bhattarai")
pdf.set_title("Homework")
pdf.set_fill_color(0, 0, 0)
pdf.set_text_color(255, 255, 255)
pdf.rect(0, 0, 8.27, 11.69, "FD")
pdf.set_xy(1.5, 4)
pdf.multi_cell(
    0, 0.5, "Name : Suphal Bhattarai \n Section : D6 \n Group : Biology", 0, 2, "C"
)

for x in ls:
    if match(".*.jpg", x):
        pdf.add_page()
        insert_img(x)

results = str(Rofi().text_entry("Whose homeowrk is this?")).upper()
result = results + "Homework" + str(date.today()) + ".pdf"
pdf.output(documents + result, "F")
os.system("evince " + documents + result + " &")

mail = email_list.emails[results]
os.system(
    "thunderbird -compose \"to='"
    + mail
    + "',subject=Homework,attachment='/home/suphal/Documents/"
    + result
    + "',body='Suphal Bhattarai (D6 Bio)'\" &"
)
