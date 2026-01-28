const mysql = require('mysql2');


const pool = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "restodb"
}).promise();

module.exports = pool;

pool.connect(function(err) {
  if (err) throw err;
  pool.query("SELECT * FROM users", function (err, result, fields) {
    if (err) throw err;
    console.log(result);
  });
});