const bcrypt = require('bcrypt');

async function loginHandler(ws, data, db) {
  const { email, password } = data;

  if (!email || !password) {
    return ws.send(JSON.stringify({
      type: 'login',
      success: false,
      message: 'Email and password required'
    }));
  }

  const snapshot = await db
    .collection('users')
    .where('email', '==', email)
    .get();

  if (snapshot.empty) {
    return ws.send(JSON.stringify({
      type: 'login',
      success: false,
      message: 'Invalid credentials'
    }));
  }

  const userDoc = snapshot.docs[0];
  const user = userDoc.data();

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return ws.send(JSON.stringify({
      type: 'login',
      success: false,
      message: 'Invalid credentials'
    }));
  }

  ws.send(JSON.stringify({
    type: 'success',
    success: true,
    user: {
      id: userDoc.id,
      name: user.name,
      email: user.email,
      phone: user.phone
    }
  }));
}

module.exports = loginHandler;
