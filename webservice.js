const db = require('./index.js');
const client = db.client;
const uuid = require('cassandra-driver').types.Uuid;

const getAllUsers = (req, res) => {
  client.execute("SELECT * FROM users.users", (err, result) => {
    if (err) {
      res.status(400);
      return res.json(err);
    }
    return res.json(result.rows);
         }); 
}

const getUserByLastName = (req, res) => {
  const lastName = req.query.lastname;
  client.execute("SELECT * FROM users.users WHERE lastname = " + lastname, (err, result) => {

  if (err) {
    res.status(400);
    return res.json(err);
  }
  
  return res.json(result.rows);
});
}

const createUser = (req, res) => {
  const lastname = req.body.lastname;
  const age = req.body.age;
  const city = req.body.city;
  const email = req.body.email;
  const firstname = req.body.firstname;
  const id = uuid.random();
  const insert = "INSERT INTO users.users (id, lastname, age, city, email, firstname) VALUES (?, ?, ?, ?, ?, ?)";
  const params = [id, lastname, age, city, email, firstname];

  client.execute(insert, params, (err, result) => {
    if(err) {
      res.status(400);
      return res.json(err);
    }
    if(result != undefined) {
      res.status(201);
      return res.json("Insert was successful");
    }
    });

}

module.exports = {
  getAllUsers,
  getUserByLastName,
  createUser
};
