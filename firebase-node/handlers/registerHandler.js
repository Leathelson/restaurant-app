const bcrypt = require('bcrypt');
const admin = require('firebase-admin');

async function registerHandler(ws, data, db) {
  const { name, phone, email, token } = data;

  if (!name || !phone || !email || !token) {
    return ws.send(JSON.stringify({
      type: 'register_error',
      success: false,
      message: 'All fields required'
    }));
  }

  await db.collection('users').add({
    name,
    phone,
    email,
    dateOfEntry: admin.firestore.Timestamp.now()
  });

  ws.send(JSON.stringify({
    type: 'register_success',
    success: true,
    message: 'User registered successfully'
  }));
}

module.exports = registerHandler;
