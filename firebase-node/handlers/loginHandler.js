const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const jwtsecret = 'pineapple'; // In production, use environment variable


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

  const token = jwt.sign(
  {userId: userDoc.id, email: user.email},
  jwtsecret,
  {expiresIn: '10d'}
);



  if (!isMatch) {
    console.log('Invalid login attempt for email:', email);

    return ws.send(JSON.stringify({
      type: 'login',
      success: false,
      message: 'Invalid credentials'
    }));
  }

  console.log('User logged in:', user.email);

  ws.send(JSON.stringify({
    type: 'login',
    success: true,
    token,
    user: {
      id: userDoc.id,
      name: user.name,
      email: user.email,
      phone: user.phone
    }
  }));
}

module.exports = loginHandler;
