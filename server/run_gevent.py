import os
import logging
from gevent import monkey
monkey.patch_all()

from gevent.pywsgi import WSGIServer
from app import app, socketio

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    
    # Set up logging for requests
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Use Flask app as WSGI application - SocketIO is already initialized on the app
    # Enable request logging by removing log=None
    server = WSGIServer(('0.0.0.0', port), app)
    logger.info(f"Starting gevent server on port {port}")
    server.serve_forever()