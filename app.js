// WEB SERVER FOR ELECTRICITY USAGE PLANNING: WEB PAGES AND AN API
// ==============================================================

// LIBRARIES AND MODULES
// ---------------------

// Use Express as web engine
const express = require('express');
// Use Express Handlebars as template engine
const {engine} = require('express-handlebars');

// Get external data with node-fetch for version 2.x
// This version should be installed as follows: npm install node-fetch@2
// const fetch = require('node-fetch');

// Get external data with node-fetch for version 3.x

import fetch from 'node-fetch';

// EXPRESS APPLICATION SETTINGS
// ----------------------------

// Create the server
const app = express();
const PORT = process.env.PORT || 8080;

// Set folder paths: public is for assets and views is for pages
app.use(express.static('public'));
app.set('views', './views');

// Engine settings
app.engine('handlebars', engine());
app.set('view engine', 'handlebars');

// URL ROUTES
// ----------

//TODO: Add date and time as dynamic data for the homepage, is it sensible to use server for creating time values?

// Route to homepage
app.get('/', (req, res) => {
    
    // Handlebars needs a key to show data on a web page, json is a good way to send it
    let homePageData = {
        'price': 31.25,
        'wind': 2,
        'temperature': 18
    }
    res.render('index', homePageData)

});

app.get('/hourly', (req, res) => {

    // Handlebars needs a key to show data on a web page, json is a good way to send it
    let hourlyPageData = { 'tableData' : [
        {'hour': 13,
        'price': 31.44},
        {'hour': 14,
        'price': 32.10},
        {'hour': 15,
        'price': 30.50},
        {'hour': 16,
        'price': 29.90}
        
    ]};

    res.render('hourly', hourlyPageData)

});

app.get('/test',(req, res) => {

    // Data will be presented in a bar chart. Data will be sent as JSON array
    let tableHours = [12, 13, 14, 15, 16];
    let jsonTableHours = JSON.stringify(tableHours)
    let tablePrices = [10, 8, 10, 12, 15];
    let jsonTablePrices = JSON.stringify(tablePrices)
    let chartPageData =  { 'hours': jsonTableHours, 'prices': jsonTablePrices };

   res.render('testCJSv4', chartPageData)

});

const LATEST_PRICES_ENDPOINT = 'https://api.porssisahko.net/v1/latest-prices.json';

async function fetchLatestPriceData() {
  const response = await fetch(LATEST_PRICES_ENDPOINT);

  return response.json();
}

function getPriceForDate(date, prices) {
  const matchingPriceEntry = prices.find(
    (price) => new Date(price.startDate) <= date && new Date(price.endDate) > date
  );

  if (!matchingPriceEntry) {
    throw 'Price for the requested date is missing';
  }

  return matchingPriceEntry.price;
}

// Note that it's enough to call fetchLatestPriceData() once in 12 hours
const { prices } = await fetchLatestPriceData();

try {
  const now = new Date();
  const price = getPriceForDate(now, prices);

  console.log(`Hinta nyt (${now.toISOString()}): ${price} snt / kWh (sis. alv)`);
} catch (e) {
  console.error(`Hinnan haku epäonnistui, syy: ${e}`);
}

// START THE LISTENER
app.listen(PORT);
console.log('Server started and it will listen TCP port', PORT);