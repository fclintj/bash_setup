import sys
reload(sys)
sys.setdefaultencoding('utf8')
from subprocess import Popen, PIPE

def paste_character(symbol):
    c = Popen(['xclip', '-selection', 'clipboard'], stdin=PIPE)
    c.communicate(symbol.encode('utf-8'))
    keyboard.send_keys('<ctrl>+<shift>+v')
    
paste_character('―')


