from flask import Flask, request
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
from comtypes import CLSCTX_ALL
import ctypes
import pythoncom
import os

app = Flask(__name__)

def set_volume(level):
    pythoncom.CoInitialize()
    devices = AudioUtilities.GetSpeakers()
    interface = devices.Activate(
        IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
    volume = ctypes.cast(interface, ctypes.POINTER(IAudioEndpointVolume))
    volume.SetMasterVolumeLevelScalar(level, None)
    pythoncom.CoUninitialize()

def shutdown_system():
    os.system("shutdown /s /t 1")  # Command to shutdown the system

@app.route('/set_volume', methods=['POST'])
def handle_set_volume():
    level = request.json.get('level')
    if level is not None and 0.0 <= level <= 1.0:
        set_volume(level)
        return 'Volume set to {}'.format(level), 200
    else:
        return 'Invalid volume level', 400

@app.route('/shutdown', methods=['POST'])
def handle_shutdown():
    shutdown_system()
    return 'Shutdown initiated', 200

@app.route('/open_facebook', methods=['POST'])
def handle_openFacebook():
    os.system("start https://www.facebook.com/")
    return 'Test successful', 200

@app.route('/open_instagram', methods=['POST'])
def handle_openInstagram():
    os.system("start https://www.instagram.com/")
    return 'Test successful', 200

@app.route('/open_gmail', methods=['POST'])
def handle_openGmail():
    os.system("start https://mail.google.com/")
    return 'Test successful', 200

@app.route('/open_youtube', methods=['POST'])
def handle_openYoutube():
    os.system("start https://www.youtube.com/")
    return 'Test successful', 200

@app.route('/restart', methods=['POST'])
def handle_restart():
    os.system("shutdown /r /t 1")

if __name__ == '__main__':
    app.run(host='192.168.0.107', port=5000)
