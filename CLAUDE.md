# Pet-Finder Application Context

## Overview
Pet-Finder is a React SPA embedded in the main website at `/Pet-Finder/` with real-time messaging functionality.

## Recent Work & Issues

### Fixed Issues ✅
- **CSS Width Consistency**: Fixed message containers and pet cards being wider than other elements

### Current Issues 🔧
- **Refresh Redirect**: STILL HAPPENING - All Pet-Finder pages except home redirect to main site on refresh
  - Tried: Flask catch-all routes with strict_slashes=False, React Router v7→v6 downgrade, homepage field in package.json
  - Root cause: Likely Render's web server serving static files directly from /client/public/Pet-Finder/, bypassing Flask
  - Next: Check Render deployment settings, try different file location, or consider HashRouter fallback
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

## Recent Debugging Session (2025-08-19)
- **React Router v7 → v6**: Downgraded due to v7 breaking entire site with basename issues
- **Added Flask debugging**: Request logging middleware and catch-all routes with emoji prefixes
- **Package.json updates**: Added "homepage": "/Pet-Finder" field
- **Current status**: Flask routes look correct but logs not visible on Render hosting

## Next Steps When Resuming
1. **Fix refresh redirect**: 
   - Check Render dashboard for static file serving settings
   - Try moving Pet-Finder build files to non-public location to force Flask routing
   - Consider HashRouter as fallback (doesn't require server-side routing)
   - Test locally to verify Flask routes work vs Render deployment
2. **Disable SocketIO completely**: Since polling fix didn't work, implement HTTP polling for real-time updates
3. **Alternative real-time**: Consider server-sent events (SSE) or simple interval-based HTTP polling