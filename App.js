const express = require('express');
const app = express();
const cors = require('cors'); // CORS NAVIGATOR API
const bodyParser = require('body-parser');


const getJson = (_, res) => {
  console.log('yes');
  res.status(200).json({
    test: true
  })
}

// Implement CORS
app.use(cors());

//SET HEADER
app.use(function(_, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.get('/test', getJson)

app.listen(5148, () => console.log('Connected'))
