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
