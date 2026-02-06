const WebSocket = require('ws');
const admin = require('firebase-admin');

const registerHandler = require('./handlers/registerHandler');
const loginHandler = require('./handlers/loginHandler');

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

(async () => {
  try {
    await db.collection('_healthcheck').limit(1).get();
    console.log('Firestore connected successfully');
  } catch (error) {
    console.error('Firestore connection failed:', error.message);
    process.exit(1); // stop server if DB not reachable
  }
})();

// Create WebSocket server
const wss = new WebSocket.Server({ port: 3000 });

console.log('WebSocket server running on port 3000');

wss.on('connection', (ws) => {
  console.log('New client connected');

  ws.on('message', async (message) => {
    try {
      const data = JSON.parse(message);

      switch (data.type) {
        case 'register':
          await registerHandler(ws, data, db);
          break;

        case 'login':
          await loginHandler(ws, data, db);
          break;

        default:
          ws.send(JSON.stringify({
            type: 'error',
            message: 'Unknown message type'
          }));
      }

    } catch (error) {
      console.error(error);
      ws.send(JSON.stringify({
        type: 'error',
        message: 'Invalid JSON format'
      }));
    }
  });

  ws.on('close', () => {
    console.log('Client disconnected');
  });
});
