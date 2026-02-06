const mysql = require('mysql2');


const pool = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "",
  database: "restodb",
  port: 3307 //for smrithi xampp
}).promise();

module.exports = pool;

pool.connect(function(err) {
  if (err) throw err;
  pool.query("SELECT * FROM users", function (err, result, fields) {
    if (err) throw err;
    console.log(result);
  });
});