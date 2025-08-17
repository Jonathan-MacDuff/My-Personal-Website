import os
from gevent import monkey
monkey.patch_all()

from gevent.pywsgi import WSGIServer
from app import app, socketio

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    # Use Flask app as WSGI application - SocketIO is already initialized on the app
    server = WSGIServer(('0.0.0.0', port), app, log=None)
    print(f"Starting gevent server on port {port}")
    server.serve_forever()