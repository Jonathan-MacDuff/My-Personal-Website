# Pet-Finder Application Context

## Overview
Pet-Finder is a React SPA embedded in the main website at `/Pet-Finder/` with real-time messaging functionality.

## Recent Work & Issues

### Fixed Issues ✅
- **CSS Width Consistency**: Fixed message containers and pet cards being wider than other elements

### Current Issues 🔧
- **Refresh Redirect**: Flask catch-all routes added but refresh still redirects to main site
- **Real-time messaging**: Recipients still need to refresh to see new messages (both Messages and Conversation pages)
- **SocketIO failures**: Polling-only transport attempted but SocketIO still not working

## Architecture

### Backend (Flask)
- Main app: `/home/jonnymanchild/Projects/My-Personal_Website/server/app.py`
- Pet-Finder blueprint registered at `/petfinder` 
- SocketIO configured with polling-only transport
- Catch-all routes serve Pet-Finder SPA: `/Pet-Finder`, `/Pet-Finder/`, `/Pet-Finder/<path:path>`

### Frontend (React)
- Built to `/home/jonnymanchild/Projects/My-Personal_Website/client/public/Pet-Finder/`
- BrowserRouter with `basename="/Pet-Finder"`
- Real-time messaging via SocketIO with HTTP fallback
- Key files:
  - `Pet-Finder/client/src/pages/Messages.js` - Main messages page with SocketIO
  - `Pet-Finder/client/src/components/Conversation.js` - Individual conversation view

## Messaging System
- **HTTP messaging**: Works reliably for sending/receiving 
- **Real-time updates**: SocketIO polling-only transport (recent change)
- **Fallback**: HTTP polling if SocketIO fails
- **Debug logging**: Extensive console logging with emoji prefixes for tracking

## Deployment
- Hosted on Render (render.com)
- Flask server with gevent + SocketIO
- Static files served from `/client/public/Pet-Finder/`

## Testing Commands
- No specific test framework identified yet
- Manual testing via browser console and network tabs

## Known Working Features
- User authentication and sessions
- HTTP-based messaging (send/receive)
- Pet listing and searching
- CSS styling and responsive design
- SPA routing within Pet-Finder

## Next Steps When Resuming
1. **Fix refresh redirect**: Investigate why Flask catch-all routes aren't working - may need server restart or different path handling
2. **Disable SocketIO completely**: Since polling fix didn't work, implement HTTP polling for real-time updates
3. **Alternative real-time**: Consider server-sent events (SSE) or simple interval-based HTTP polling