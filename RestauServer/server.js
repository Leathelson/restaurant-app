const WebSocket = require('ws');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');
const db = require('./db');
const { handleRegister, handleLogin } = require('./handlers');

// Create WebSocket server
const wss = new WebSocket.Server({ port: 3000 });

console.log('WebSocket server running on port 3000');

// Ensure database connection
(async () => {
  try {
    await db.connect();
    console.log('Connected to the database');
  } catch (error) {
    console.error('Database connection failed:', error);
    process.exit(1);
  }
})();

// Handle WebSocket connections
wss.on('connection', (ws) => {
  console.log('New client connected');

  ws.on('message', async (message) => {
    try {
      const data = JSON.parse(message);
      console.log('Received:', data);

      if (data.type === 'register') {                  // Registration handler
        await handleRegister(ws, data);
        console.log('Registration handled');
      }

      if (data.type === 'login') {                     // Login handler
        await handleLogin(ws, data);
        console.log('login handled');
      }

    } catch (error) {
      console.error('Error processing message:', error);
      ws.send(JSON.stringify({ type: 'error', message: 'Invalid JSON' }));
    }
  });

  ws.on('close', () => {
    console.log('Client disconnected');
  });
})

