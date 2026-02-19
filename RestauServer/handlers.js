// Register handler
const db = require('./db');
const bcrypt = require('bcrypt');

async function handleRegister(ws, data = {}) {
  const { name, phone, email, password } = data;

  if (!name || !phone || !email || !password) {
    ws.send(JSON.stringify({ 
        type: 'register',
        success: false,
        message: 'All fields are required' }));
    return;
  }

  const [existingUser] = await db.query('SELECT * FROM users WHERE email = ?', [email]);

  if (existingUser.length > 0) {
    ws.send(JSON.stringify({ 
        type: 'register_success',
        success: false,
        message: 'Email already registered' }));
    return;
  }

  const hashedPassword = await bcrypt.hash(password, 10);
    await db.query('INSERT INTO users (name, phone, email, password) VALUES (?, ?, ?, ?)',
    [name, phone, email, hashedPassword]);

    ws.send(JSON.stringify({ 
        type: 'register_success',
        success: true,
        message: 'register_success' }));
}

// Login handler
async function handleLogin(ws, data) {
    const { email, password } = data;

    const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);

    if (users.length === 0) {
        ws.send(JSON.stringify({ 
            type: 'login',
            success: false,
            message: 'Invalid email' }));
        return;
    }

    const user = users[0];
    const passwordMatch = await bcrypt.compare(password, user.password);

    if (!passwordMatch) {
        ws.send(JSON.stringify({ 
            type: 'login',
            success: false,
            message: 'password' }));
        return;
    }

    ws.send(JSON.stringify({ 
        type: 'login',
        success: true,
        message: 'login',
        userId: user.id }));
    
}

//testing insertions
async function testInsert() {
    const name = "Test User";
    const phone = "1234567890";
    const email = "testing@gmail.com";
    const password = "testpassword";

    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query('INSERT INTO users (name, phone, email, password) VALUES (?, ?, ?, ?)',
    [name, phone, email, hashedPassword]);

    console.log('Test user inserted');
}

module.exports = { handleRegister, handleLogin };