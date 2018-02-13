const db = require('./index.js');
const client = db.client;

const getAllUsers = (req, res) => {
  client.execute("SELECT * FROM users.users", (err, result) => {
    if (err) 
      return res.json(err);
              
    return res.json(result.rows);
         }); 
}

const getUserByLastName = (req, res) => {
  const lastName = req.query.lastname;
  client.execute("SELECT * FROM users.users WHERE lastname = " + lastname, (err, result) => {

  if (err)
    return res.json(err);
  
  return res.json(result.rows);
});
}

const createUser = (req, res) => {
  const lastname = req.body.lastname;
  const age = req.body.age;
  const city = req.body.city;
  const email = req.body.email;
  const firstname = req.body.firstname;
  const insert = "INSERT INTO users.users (id, lastname, age, city, email, firstname) VALUES=?";
  const params = [uuid(), lastname, age, city, email, firstname];

  client.execute(insert, params (err, result) => {
    if(err)
      return res.json(err);
    if(result != undefined)
      return res.json("Insert was successful");
    });

}

module.exports = {
  getAllUsers,
  getUserByLastName,
  createUser
};
