const bodyParser = require('body-parser');
const express = require('express');
const path = require('path');
const db = require('./index.js');
const api = require('./webservice.js');

const app = express();
const conn = db.client;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', getAllEntries);

app.listen(8080, '0.0.0.0');
console.log("Server running on port 8080");
