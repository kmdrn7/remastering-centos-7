from flask import Flask, render_template, request
from flask import redirect, url_for
from flask_debugtoolbar import DebugToolbarExtension
from flask_socketio import SocketIO
from gevent import monkey; monkey.patch_all()
from threading import Lock

async_mode = "gevent"
app = Flask(__name__,
            static_url_path='',
            static_folder='static',
            template_folder='templates')
app.config.from_object('config')

socketio = SocketIO(app, async_mode=async_mode);
thread = None
thread_lock = Lock()

toolbar = DebugToolbarExtension(app)

@app.route('/')
def index():
    return redirect(url_for('dashboard.index'))

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

# Import modul / komponen dengan menggunakan blueprint
from app.mod_dashboard.controllers import mod_dashboard
from app.mod_server.controllers import mod_server

# Register blueprint yang telah diimport
app.register_blueprint(mod_dashboard)
app.register_blueprint(mod_server)