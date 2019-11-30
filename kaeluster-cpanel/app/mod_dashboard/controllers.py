from ansi2html import Ansi2HTMLConverter
from app import socketio, thread, thread_lock
from time import sleep
from flask import Blueprint, request, render_template, Response
from flask_socketio import emit, send
from slugify import slugify
from threading import Thread
import paramiko

mod_dashboard = Blueprint('dashboard', __name__, url_prefix='/dashboard')

conv = Ansi2HTMLConverter()
host = "192.168.10.1"
user = "kmdr7"
_psw = "kmdrin007"

@mod_dashboard.route('/', methods=['GET'])
def index():
    data = {
        'title': "Dashboard",
    }

    return render_template('dashboard/index.html', data=data)

@mod_dashboard.route('/run', methods=['GET'])
def run():
    data = {
        'title': "Run Provisioning Server",
    }
    return render_template('dashboard/run.html', data=data, async_mode=socketio.async_mode)

@mod_dashboard.route('/test', methods=['GET'])
def test():

    request = {
        'server': slugify('Server Baru'),
        'username': 'master',
        'password': 'master',
        'ukuran_disk': 20
    }

    commands = [
        "cd /work/code/remastering-centos-7/kaeluster-master",
        # "mkdir ",
        # "packer build slave.json"
    ]
    def runCommand():
        try:
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(hostname=host, port=int(22), username=user, password=_psw)
            stdin, stdout, stderr = ssh.exec_command(commands[0])
            for line in iter(stdout.readline, ''):
                yield conv.convert(line).replace('\n', '')+'<br>'
        except Exception as e:
            print (e)

    data = {
        'title': "Run Provisioning Server Test",
    }
    # return Response(runCommand(), mimetype='text/html')

class CmdThread(Thread):
    def __init__(self):
        super().__init__()
    def runCmd(self):
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(hostname=host, port=int(22), username=user, password=_psw)
        stdin, stdout, stderr = ssh.exec_command("cd /work/code/remastering-centos-7/kaeluster-master; packer build slave.json")
        for line in iter(stdout.readline, ''):
            socketio.emit('stdout', conv.convert(line).replace('\n', '')+'<br>')
            socketio.sleep(0)
    def run(self):
        self.runCmd()

@socketio.on('connect')
def onConnect():
    trd = CmdThread()
    trd.start()