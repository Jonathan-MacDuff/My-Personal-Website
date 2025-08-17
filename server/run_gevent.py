import os
import logging
import subprocess
from gevent import monkey
monkey.patch_all()

from gevent.pywsgi import WSGIServer
from app import app, socketio

def initialize_database():
    """Run migration and seeding script if database is empty"""
    try:
        with app.app_context():
            from petfinder.extensions import db
            # Check if tables exist and have data
            result = db.engine.execute("SELECT COUNT(*) FROM users")
            user_count = result.scalar()
            if user_count > 0:
                print("Database already has data, skipping initialization")
                return
    except Exception:
        print("Database not initialized, running migration and seed...")
        
    # Run the migration script with automatic "yes" to seeding
    try:
        # Change to scripts directory and run migration with auto-yes
        script_dir = os.path.join(os.path.dirname(__file__), '..', 'scripts')
        result = subprocess.run(
            ['bash', './migrate-petfinder.sh'],
            input='y\n',
            text=True,
            cwd=script_dir,
            capture_output=True
        )
        if result.returncode == 0:
            print("Database migration and seeding completed successfully")
        else:
            print(f"Migration failed: {result.stderr}")
    except Exception as e:
        print(f"Error running migration script: {e}")

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    
    # Set up logging for requests
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Initialize database on startup
    initialize_database()
    
    # Use Flask app as WSGI application - SocketIO is already initialized on the app
    server = WSGIServer(('0.0.0.0', port), app)
    logger.info(f"Starting gevent server on port {port}")
    server.serve_forever()