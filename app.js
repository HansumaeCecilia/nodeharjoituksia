// WEB SERVER FOR ELECTRICITY USAGE PLANNING: WEB PAGES AND AN API
// ==============================================================

// LIBRARIES AND MODULES
// ---------------------

// Use Express as web engine
const express = require('express');
// Use Express Handlebars as template engine
const {engine} = require('express-handlebars');

// EXPRESS APPLICATION SETTINGS
// ----------------------------

// Create the server
const app = express();
const PORT = process.env.PORT || 8080;

// Set folder paths: public is for assets and views for pages
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

// START THE LISTENER
app.listen(PORT);
console.log('Server started and it will listen TCP port', PORT);