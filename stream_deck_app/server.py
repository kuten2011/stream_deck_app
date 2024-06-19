from flask import Flask, request
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
from comtypes import CLSCTX_ALL
import ctypes
import pythoncom

app = Flask(__name__)

def set_volume(level):
    pythoncom.CoInitialize()  # Gọi hàm CoInitialize
    devices = AudioUtilities.GetSpeakers()
    interface = devices.Activate(
        IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
    volume = ctypes.cast(interface, ctypes.POINTER(IAudioEndpointVolume))
    volume.SetMasterVolumeLevelScalar(level, None)
    pythoncom.CoUninitialize()  # Gọi hàm CoUninitialize

@app.route('/set_volume', methods=['POST'])
def handle_set_volume():
    level = request.json.get('level')
    if level is not None and 0.0 <= level <= 1.0:
        set_volume(level)
        return 'Volume set to {}'.format(level), 200
    else:
        return 'Invalid volume level', 400

if __name__ == '__main__':
    app.run(host='192.168.0.107', port=5000)
