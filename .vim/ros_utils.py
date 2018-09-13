import subprocess
import sys
import threading
import rospy
import time


def main():
    # run_launch( workspace=sys.argv[1], launch_file=sys.argv[2])
    l = LaunchFile("/home/clint/dev/RFID_project/") 
    
    l.rosrun("piksi_nmea_navsat_driver nmea_topic_serial_reader _port:=/dev/ttyUSB1 _baud:=1000000")
    l.rosrun("piksi_nmea_navsat_driver nmea_topic_serial_reader _port:=/dev/ttyUSB2 _baud:=1000000")
    print("here I am ")
    time.sleep(2000)


class LaunchFile:
    def __init__(self,workspace):
        self.workspace = workspace 

    def call(self, command):
        print(command)
        bash =''' 
            cd ''' + self.workspace + '''
            source ./devel/setup.bash
            pwd
            rosrun ''' + command + '''
            '''
        subprocess.call(['bash', '-c',bash])

    def rosrun(self, command):
        threading.Thread(target=self.call(command)).start()



def run_launch(workspace,launch_file):
    bash =''' 
        cd ''' + workspace + '''
        pwd 
        source ./devel/setup.bash
        echo $ROS_DISTRO
        roslaunch ''' + launch_file + '''
        '''

    subprocess.call(['bash', '-c',bash])

def tmp():
    workspace = "/home/clint/dev/RFID_project/"

    bash =''' 
        cd ''' + workspace + '''
        source ./devel/setup.bash
        echo $ROS_DISTRO
        rosrun piksi_nmea_navsat_driver nmea_topic_serial_reader _port:=/dev/ttyUSB1 _baud:=1000000
        '''

    subprocess.call(['bash', '-c',bash])
    



if __name__ == '__main__':
  main()
