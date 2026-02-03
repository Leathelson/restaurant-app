const bcrypt = require('bcrypt');
const admin = require('firebase-admin');

async function registerHandler(ws, data, db) {
  const { name, phone, email, password } = data;

  if (!name || !phone || !email || !password) {
    return ws.send(JSON.stringify({
      type: 'register',
      success: false,
      message: 'All fields required'
    }));
  }

  const existingUser = await db
    .collection('users')
    .where('email', '==', email)
    .get();

  if (!existingUser.empty) {
    return ws.send(JSON.stringify({
      type: 'register',
      success: false,
      message: 'Email already registered'
    }));
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  await db.collection('users').add({
    name,
    phone,
    email,
    password: hashedPassword,
    dateOfEntry: admin.firestore.Timestamp.now()
  });

  ws.send(JSON.stringify({
    type: 'register',
    success: true,
    message: 'User registered successfully'
  }));
}

module.exports = registerHandler;
