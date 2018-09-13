import subprocess
import sys

def main():
    workspace=sys.argv[1]
    launch_file=sys.argv[2]

    bash =''' 
        cd ''' + workspace + '''
        pwd 
        source ./devel/setup.bash
        echo $ROS_DISTRO
        roslaunch ''' + launch_file + '''
        '''

    subprocess.call(['bash', '-c',bash])

if __name__ == '__main__':
  main()
