const bodyParser = require('body-parser');
const express = require('express');
const path = require('path');
const db = require('./connectToCassandra.js');
const api = require('./webservice.js');

const app = express();
const conn = db.client;
const getAllEntries = api.getAllUsers;
const getUserByLastName = api.getUserByLastName;
const createUser = api.createUser;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/users', getAllEntries);
app.get('/user/:lastname?', getUserByLastName);
app.post('/user', createUser);
app.get('/', (req, res) => res.sendFile(path.join(__dirname + '/home.html')));

app.listen(8080, '0.0.0.0');
console.log("Server running on port 8080");
