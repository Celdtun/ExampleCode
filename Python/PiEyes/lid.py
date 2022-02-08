import sys
import board
import busio
import adafruit_pca9685
import time

sys.path.append("/usr/local/lib/python3.7/dist-packages")
from adafruit_servokit import ServoKit
kit = ServoKit(channels=16)

#kit.servo[0].angle = 0
#time.sleep( 0.5)

pos = 90

if len( sys.argv) == 1:
    pos = sys.argv[ 1]
else :
    kit.servo[ 1].enabled = false

kit.servo[ 0].angle = pos
