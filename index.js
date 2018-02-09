var cassandra = require('cassandra-driver');
var async = require('async');
 
var client = new cassandra.Client({contactPoints: ['172.30.224.244']});
client.connect()
 .then( () => {
  var keyspace = "CREATE KEYSPACE IF NOT EXISTS users " +
                 "WITH REPLICATION = { " +
                  "'class' : 'SimpleStrategy', " +
                  "'replication_factor' : 1 " +
                  "};";

  return client.execute(keyspace);
});
.then( () => {
var table = "CREATE TABLE users(" + 
                                   "id UUID PRIMARY KEY," +
                                   "lastname TEXT," + 
                                   "age INT," +
                                   "city TEXT, " +
                                   "email TEXT," +
                                   "firstname TEXT );";
   client.execute(table);
});
.catch((err) => {
 console.log(err);
});

// Use async series to run functions in serial (one after another)
async.series([
    // Insert Bob
    function (callback) {
        client.execute("INSERT INTO users (lastname, age, city, email, firstname) VALUES ('Jones', 35, 'Austin', 'bob@example.com', 'Bob')", function (err, result) {
            // Run next function in series
            console.log("Insert was successful");
            callback(err, null);
        });
    },
    // Read users and print to console
    function (callback) {
        client.execute("SELECT lastname, age, city, email, firstname FROM users WHERE lastname='Jones'", function (err, result) {
            if (!err){
                if ( result.rows.length > 0 ) {
                    var user = result.rows[0];
                    console.log("name = %s, age = %d", user.firstname, user.age);
                } else {
                    console.log("No results");
                }
            }
            
            // Run next function in series
            callback(err, null);
        });
    },
    // Update Bob's age
    function (callback) {
        client.execute("UPDATE users SET age = 36 WHERE lastname = 'Jones'", function (err, result) {
            // Run next function in series
            callback(err, null);
        });
    },
    // Read users and print to the console
    function (callback) {
        client.execute("SELECT firstname, age FROM users where lastname = 'Jones'", function (err, result) {
            var user = result.rows[0];
            console.log("name = %s, age = %d", user.firstname, user.age);
            
            // Run next function in series
            callback(err, null);
        });
    },
    // Delete Bob
    function (callback) {
        client.execute("DELETE FROM users WHERE lastname = 'Jones'", function (err, result) {
            if (!err) {
                console.log("Deleted");
            }
            
            // Run next function in series
            callback(err, null);
        });
    },
    // Read users and print to the console
    function (callback) {
        client.execute("SELECT * FROM users WHERE lastname='Jones'", function (err, result) {
            if ( result.rows.length > 0 ) {
                var user = result.rows[0];
                console.log("name = %s, age = %d", user.firstname, user.age);
            } else {
                console.log("No records");
            }
            
            // Run next function in series
            callback(err, null);
        });
    }
]);
