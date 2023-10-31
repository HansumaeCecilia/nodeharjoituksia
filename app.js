// WEB SERVER FOR ELECTRICITY USAGE PLANNING: WEB PAGES AND AN API
// ==============================================================

// LIBRARIES AND MODULES
// ---------------------

// Use Express as web engine
const express = require('express');
// Use Express Handlebars as template engine
const {engine} = require('express-handlebars');
const cprice = require('./getHomePageData')
const cpriceTable = require('./getHourlyPageData')
const cpriceChart = require('./getBarChartData')

// Get external data with node-fetch for version 2.x
// This version should be installed as follows: npm install node-fetch@2
// const fetch = require('node-fetch');

// Get external data with node-fetch for version 3.x

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
        'price': 0,
        'wind': 0,
        'temperature': 18
    }

    cprice.getCurrentPrice().then((resultset) => {
        console.log.apply(resultset.rows[0])
        homePageData.price = resultset.rows[0]['price']
    })

    res.render('index', homePageData)

});

// Route to hourly data page
app.get('/hourly', (req, res) => {

    // Data will be presented in a table. To loop all rows we need a key for table and for column data
    cpriceTable.getCurrentPriceTable().then((resultset) => {
        let tableData = resultset.rows
        let hourlyPageData = {
            'tableData': tableData
        };
        console.log(hourlyPageData)
        res.render('hourly', hourlyPageData)
    })
    
});

// Route to hourly chart page
// app.get('/chart',(req, res) => {
    
//     // Data will be presented in a bar chart. Data will be sent as JSON array to get it work on handlebars page
//     let tableHours = [12, 13, 14, 15, 16];
//     let jsonTableHours = JSON.stringify(tableHours)
//     let tablePrices = [10, 8, 10, 12, 15];
//     let jsonTablePrices = JSON.stringify(tablePrices)
//     let chartPageData =  { 'hours': jsonTableHours, 'prices': jsonTablePrices };
//     res.render('chart', chartPageData)
// });

// Route to hourly chart page graph.handlebars
app.get('/graph', (req, res) => {
    cpriceChart.getCurrentPriceChartData().then((resultset) => {
        let xyData = resultset.rows

        // Create empty arrays for x-axis and y-axis data
        let xData = []
        let yData = []

        // Add values to those arrays in a loop
        for (i in xyData) {
            let xvalueStr = xyData[i]['hour'];

            // Time valuest must be converted to numbers for the chart to render
            let xvalue = Number(xvalueStr)
            xData.push(xvalue)

            // Price values are numbers so no need to convert
            let yvalue = xyData[i]['price'];
            yData.push(yvalue)
        }
        // Data will be presented in a bar chart. Data will be sent as JSON array
        xData = JSON.stringify(xData)
        yData = JSON.stringify(yData)

        // X-axis values are called hours and y-axis values prices in the handlebars file
        let chartPageData = { 'hours': xData, 'prices': yData };

        // Render and send dynamic data to the page 
        res.render('graph', chartPageData)
    });


});

// START THE LISTENER
app.listen(PORT);
console.log('Server started and it will listen TCP port', PORT);