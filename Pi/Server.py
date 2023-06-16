import socketserver
import http.server
import logging
import cgi
import RPi.GPIO as GPIO
import os
import time


PORT = 8080
p = {"Text1":"","Text2":"", "Text3":"","Text4":""}
meow = [0,0,0,0]
blst = [1,4,1,1]
class ServerHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        logging.error(self.headers)
        print("abce")
        http.server.SimpleHTTPRequestHandler.do_GET(self)
        print(self.path)
        i = self.path.index ( "?" ) + 1
        global p
        p = dict ( [ tuple ( p.split("=") ) for p in self.path[i:].split ( "&" ) ] )
        global meow
        meow.clear()
        for val in p.values():
            lst = val.split("%20")
            meow.append(len(lst))
        global blst
        
        for i in range(4):
            blst[i] = (int(((meow[i]/120)+meow[i])*10000))
    def do_POST(self):
        logging.error(self.headers)
        form = cgi.FieldStorage(
            fp=self.rfile,
            headers=self.headers,
            environ={'REQUEST_METHOD':'POST',
                     'CONTENT_TYPE':self.headers['Content-Type'],
                     })
        for item in form.list:
            logging.error(item)
        http.server.SimpleHTTPRequestHandler.do_GET(self)

        with open("data.txt", "w") as file:
            for key in form.keys(): 
                file.write(str(form.getvalue(str(key))) + ",")


Handler = ServerHandler

httpd = socketserver.TCPServer(("", PORT), Handler)
def button_callback(channel):
    print("button blcik")
    text = ""
    c = 0
    if channel == 10 and channel != c:
        print(channel)
        text = p["Text4"]
        lst = text.split("%20")
        text1 = ""
        for i in lst:
            text1 = text1 + " " + i
        cmd = './speech.sh ' + text1
        c = 10
        os.system(cmd)
    elif channel == 12 and channel != c:
        print(channel)
        text = p["Text3"]
        lst = text.split("%20")
        text1 = ""
        for i in lst:
            text1 = text1 + " " + i
        c = 12
        cmd = './speech.sh ' + text1
        os.system(cmd)
    elif channel == 16 and channel != c:
        print(channel)
        text = p["Text2"]
        lst = text.split("%20")
        text1 = ""
        for i in lst:
            text1 = text1 + " " + i
        c = 16
        cmd = './speech.sh ' + text1
        os.system(cmd)
    elif channel == 18 and channel != c:
        print(channel)
        text = p["Text1"]
        lst = text.split("%20")
        text1 = ""
        for i in lst:
            text1 = text1 + " " + i
        c = 18
        cmd = './speech.sh ' + text1
        os.system(cmd)
GPIO.setwarnings(False) 
GPIO.setmode(GPIO.BOARD)
GPIO.setup(10, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(12, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(16, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(18, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
GPIO.add_event_detect(10,GPIO.FALLING,callback= lambda x : button_callback(10), bouncetime = 5000)
GPIO.add_event_detect(12,GPIO.FALLING,callback= lambda x : button_callback(12), bouncetime = 5000)
GPIO.add_event_detect(16,GPIO.FALLING,callback= lambda x : button_callback(16), bouncetime = 5000)
GPIO.add_event_detect(18,GPIO.FALLING,callback= lambda x : button_callback(18), bouncetime =5000)     
print("serving at port", PORT)
httpd.serve_forever()
