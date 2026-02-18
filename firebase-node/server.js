const WebSocket = require('ws');
const admin = require('firebase-admin');

const express = require('express');
const app = express();

const registerHandler = require('./handlers/registerHandler');
const loginHandler = require('./handlers/loginHandler');

const serviceAccount = require('./firebaseServiceKey.json');



// Create WebSocket server
const server = app.listen(3000, () => {
  console.log('Server running on port 3000');
});


const wss = new WebSocket.Server({ port: server });


console.log('WebSocket server running on port 3000');

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

//middleware to handle JSON parsing errors

const verifyFirebaseToken = async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "No token provided" });
  }

  const idToken = authHeader.split("Bearer ")[1];

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken; // contains uid, email, etc.
    next();
  } catch (error) {
    return res.status(403).json({ message: "Invalid or expired token" });
  }
};

app.get('/protected', verifyFirebaseToken, (req, res) => {
  res.json({
    message: "You are authenticated!",
    user: req.user
  });
});






wss.on('connection', (ws) => {
  console.log('New client connected');
  
  ws.on('message', async (message) => {
    if (message) {

    try {
      const parsed = JSON.parse(message);
      const {event, data} = parsed;

    if (event === 'firebase_login') {
      const token = data?.token; // safely get token
      if (!token) {
        ws.send(JSON.stringify({
          event: 'firebase_login_error',
          message: 'No token provided'
        }));
        return;
      }

      const decodedToken = await admin.auth().verifyIdToken(token);

      await db.collection('users').doc(decodedToken.uid).set({
        name: decodedToken.name || 'Unknown',
        email: decodedToken.email,
        phone: decodedToken.phone_number || 'Unknown',
        lastLogin: admin.firestore.Timestamp.now()
      }, { merge: true });

        ws.send(JSON.stringify({
          event: 'registerData',
          data: {
            success: true,
            uid: decodedToken.uid,
            email: decodedToken.email
          }
        }));
      }
    
    if (event === 'register') {
      await registerHandler(ws, data, db);
      console.log('Register event handled');
    }  

    } catch (error) {
      console.error(error);
      ws.send(JSON.stringify({
        event: 'register_error',
        message: 'Invalid Firebase token'
      }));
    }
  }
});



  ws.on('close', () => {
    console.log('Client disconnected');
  });
});

