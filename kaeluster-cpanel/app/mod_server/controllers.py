from flask import Blueprint, request, Response, render_template, jsonify

mod_server = Blueprint('server', __name__, url_prefix='/server')

@mod_server.route('/', methods=['GET'])
def index():
    data = {
        'title': "Data Server",
    }
    return render_template('server/index.html', data=data)

@mod_server.route('/new', methods=['GET'])
def new():
    data = {
        'title': "Buat Server Baru",
    }
    return render_template('server/baru.html', data=data)

@mod_server.route('/create', methods=['POST'])
def create():
    data = {
        'title': "Simpan Server Baru",
    }
    # return Response('req')
    return render_template('server/baru.html', data=data)