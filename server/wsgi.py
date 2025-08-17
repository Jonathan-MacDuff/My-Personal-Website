from gevent import monkey
monkey.patch_all()

from app import app, socketio

# For standard WSGI servers that don't support SocketIO
application = app

# For gevent deployment, use socketio WSGI app
# This handles both HTTP and WebSocket connections
if __name__ == '__main__':
    socketio.run(app, debug=False)