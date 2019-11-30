from app import app, socketio

# Run flask without socketio binding
# app.run(port=3121, host='0.0.0.0')

# Run flask with socketio binding
socketio.run(app=app, port=3121, host='0.0.0.0')