import sys
import board
import busio
import adafruit_pca9685
import time

sys.path.append("/usr/local/lib/python3.7/dist-packages")
from adafruit_servokit import ServoKit
kit = ServoKit(channels=16)

kit.servo[0].angle = 0
time.sleep( 0.5)
kit.servo[0].angle = 180
time.sleep( 0.5)
kit.servo[0].angle = 0
time.sleep( 0.5)
kit.servo[0].angle = 180
time.sleep( 0.5)
