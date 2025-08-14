from .extensions import db, socketio
from datetime import datetime

@socketio.on('message')
def handle_message(data):
    from .models import Message
    
    try:
        sender_id = data.get('sender_id')
        recipient_id = data.get('recipient_id')
        content = data.get('content')
        timestamp = datetime.fromisoformat(data.get('timestamp').replace('Z', ''))
        
        new_message = Message(
            sender_id=sender_id, 
            recipient_id=recipient_id, 
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
            'recipient_id': new_message.recipient_id,
            'content': new_message.content,
            'timestamp': new_message.timestamp.isoformat()
        }
        socketio.emit('message', saved_message, broadcast=True)
    except Exception as e:
        print(f"SocketIO message error: {e}")
