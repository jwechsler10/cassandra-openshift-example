const getAllUsers = (req, res) => {

        client.execute("SELECT * FROM users", (err, result) => {
        if (err) 
          return res.json(err);
              
        return res.json(result.rows);
         }); 
}

module.exports = {
  getAllUsers
};
