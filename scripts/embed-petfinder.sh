#!/bin/bash

set -e

cd ../Pet-Finder/client || exit

echo "Updating BACKEND_URL for production..."
sed -i.bak 's|const BACKEND_URL = ""|const BACKEND_URL = "https://my-personal-website-ss2x.onrender.com/petfinder"|' src/config.js
sed -i.bak 's|const socket = io("http://localhost:5555"|const socket = io("https://my-personal-website-ss2x.onrender.com"|' src/components/Conversation.js

echo "Switching to HashRouter for embedded deployment..."
sed -i.bak2 's|import { BrowserRouter }|import { HashRouter }|' src/index.js
sed -i 's|<BrowserRouter basename="/Pet-Finder">|<HashRouter>|' src/index.js
sed -i 's|</BrowserRouter>|</HashRouter>|' src/index.js

PUBLIC_URL=/Pet-Finder npm run build

mv src/config.js.bak src/config.js
mv src/components/Conversation.js.bak src/components/Conversation.js
mv src/index.js.bak2 src/index.js

rm -rf ../../client/public/Pet-Finder/*
cp -r build/* ../../client/public/Pet-Finder/

echo "Pet Finder React app embedded successfully!"

echo "Syncing Pet Finder backend..."

SRC_BACKEND_DIR="../server"
DEST_BACKEND_DIR="../../server/petfinder"

# rsync excluding migrations folder and database files (app.db, instance folder, migrations)
rsync -av --exclude='__pycache__' --exclude='*.pyc' --exclude='*.pyo' --exclude='migrations' --exclude='instance' --exclude='app.db' --exclude='run.py' --exclude='.env' --exclude='requirements.txt' "$SRC_BACKEND_DIR/" "$DEST_BACKEND_DIR/"

echo "Converting absolute imports back to relative for embedded version..."
find "$DEST_BACKEND_DIR" -name "*.py" -exec sed -i 's/from extensions/from .extensions/g' {} \;
find "$DEST_BACKEND_DIR" -name "*.py" -exec sed -i 's/from models/from .models/g' {} \;
find "$DEST_BACKEND_DIR" -name "*.py" -exec sed -i 's/from config/from .config/g' {} \;
find "$DEST_BACKEND_DIR" -name "*.py" -exec sed -i 's/from routes/from .routes/g' {} \;
find "$DEST_BACKEND_DIR" -name "*.py" -exec sed -i 's/from __init__/from ./g' {} \;

# Fix the __init__.py to not create an app, just expose what's needed
cat > "$DEST_BACKEND_DIR/__init__.py" << 'EOF'
# Expose the blueprint and models for import
from .routes import petfinder_bp
from .models import User, Pet, Report, Comment, Message
from .extensions import db, migrate, socketio
EOF

# Convert Flask app to Blueprint in routes.py
echo "Converting routes.py to use Blueprint..."

# Add the blueprint import and creation at the top
sed -i '1i\
from flask import Blueprint\
petfinder_bp = Blueprint("petfinder", __name__)\
\
# Keep your CORS setup for the blueprint\
from flask_cors import CORS\
CORS(petfinder_bp, origins=["https://autistic-insight.com", "https://www.autistic-insight.com"], supports_credentials=True)\
' "$DEST_BACKEND_DIR/routes.py"

# Clean up the file - remove shebang, placeholder comments, and fix imports
sed -i '/^#!/d' "$DEST_BACKEND_DIR/routes.py"
sed -i 's/from flask_restful import Api//' "$DEST_BACKEND_DIR/routes.py"

# Fix the register_routes function signature
sed -i 's/def register_routes(api):/def register_routes():/' "$DEST_BACKEND_DIR/routes.py"

# Add the API initialization at the end
cat >> "$DEST_BACKEND_DIR/routes.py" << 'EOF'

# Initialize the API with the blueprint
register_routes()
api.init_app(petfinder_bp)
EOF

# Update extensions.py to remove duplicate SocketIO config
cat > "$DEST_BACKEND_DIR/extensions.py" << 'EOF'
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_restful import Api
from flask_cors import CORS
from flask_socketio import SocketIO

db = SQLAlchemy()
migrate = Migrate()
api = Api()
cors = CORS()
socketio = SocketIO()
EOF

# Create a socketio_handlers.py file for SocketIO message handling
cat > "$DEST_BACKEND_DIR/socketio_handlers.py" << 'EOF'
from .extensions import db, socketio
from datetime import datetime

@socketio.on('message')
def handle_message(data):
    from .models import Message, User
    
    try:
        sender_id = data.get('sender_id')
        recipient_username = data.get('recipient')
        content = data.get('content')
        timestamp = datetime.fromisoformat(data.get('timestamp').replace('Z', ''))
        
        # Look up recipient by username
        recipient = User.query.filter(User.username == recipient_username).first()
        if not recipient:
            print(f"Recipient '{recipient_username}' not found")
            return
            
        new_message = Message(
            sender_id=sender_id, 
            recipient_id=recipient.id, 
            content=content, 
            timestamp=timestamp
        )
        db.session.add(new_message)
        db.session.commit()
        
        saved_message = {
            'id': new_message.id,
            'sender': {
                'id': new_message.sender.id,
                'username': new_message.sender.username
            },
            'recipient': {
                'id': new_message.recipient.id,
                'username': new_message.recipient.username
            },
            'recipient_id': new_message.recipient_id,
            'content': new_message.content,
            'timestamp': new_message.timestamp.isoformat()
        }
        socketio.emit('message', saved_message, broadcast=True)
    except Exception as e:
        print(f"SocketIO message error: {e}")
EOF

# Fix seed.py imports for blueprint structure
echo "Fixing seed.py imports..."
if [ -f "$DEST_BACKEND_DIR/seed.py" ]; then
    # Replace the problematic imports with main app imports
    sed -i 's|from \. import create_app|import sys\nimport os\n# Add parent directory to path for main app import\nsys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))\nfrom app import app|' "$DEST_BACKEND_DIR/seed.py"
    
    # Remove the create_app() call and use imported app
    sed -i 's|app = create_app()|# Use the imported main app directly|' "$DEST_BACKEND_DIR/seed.py"
    
    echo "seed.py imports fixed for blueprint structure"
else
    echo "seed.py not found, skipping seed fixes"
fi

echo "Backend synced and converted to blueprint in $DEST_BACKEND_DIR"

# Create a setup instructions file
cat > "$DEST_BACKEND_DIR/INTEGRATION_NOTES.txt" << 'EOF'
INTEGRATION NOTES FOR PETFINDER BLUEPRINT:

1. In your main server/app.py, add these imports:
   from petfinder.extensions import db, migrate, socketio
   from petfinder.routes import petfinder_bp
   from petfinder.config import Config
   import petfinder.socketio_handlers  # This registers the SocketIO handlers

2. Configure your main app:
   app.config.from_object(Config)  # or merge config as needed
   
3. Initialize extensions:
   db.init_app(app)
   migrate.init_app(app, db)
   socketio.init_app(app, cors_allowed_origins="*", transports=["websocket"])

4. Register the blueprint:
   app.register_blueprint(petfinder_bp, url_prefix="/petfinder")

5. Run with SocketIO:
   if __name__ == "__main__":
       socketio.run(app, debug=True)
EOF

echo "Pet Finder fully embedded with integration notes!"
echo "Check $DEST_BACKEND_DIR/INTEGRATION_NOTES.txt for setup instructions."