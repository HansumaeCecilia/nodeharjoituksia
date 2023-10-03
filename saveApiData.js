const Pool = require('pg').Pool;
const cron = require('node-cron');
const getPrices = require('./getNewPrices')
const fs = require('fs');

const pool = new Pool({
  user: 'postgres', // In production always create a new user for the app
  password: 'Q2werty',
  host: 'localhost', // localhost or 127.0.0.1 if in the same computer, otherwise IP
  database: 'smarthome',
  port: 5432
});

let lastFetchedDate = '1.1.2023';

cron.schedule('*/5 15 * * * *', () => {
  try {
    let timestamp = new Date(); // Get the current timestamp
    let dateStr = timestamp.toLocaleDateString(); // Take datepart of the timestamp

    // If the date of last sucessful fetch is not the current day, fetch data
    if (lastFetchedDate != dateStr) {
      console.log('Started fetching price data');
      fs.appendFileSync('dateOperations.log', 'Started fetching data ');            
      getPrices.fetchLatestPriceData().then((json) => {

        // Loop trough prices data and pick starDate and price elements
        json.prices.forEach(async (element) => {
          let values = [element.startDate, element.price];

          // Build a SQL clause to insert values into table
          const sqlClause = 'INSERT INTO public.hourly_price_api (timeslot_2, price_2) VALUES ($1, $2) ON CONFLICT DO NOTHING RETURNING *';
           
          // Function for running SQL operations asyncroneously
          const runQuery = async () => {
            let resultset = await pool.query(sqlClause, values);
            //fs.appendFileSync('dataOperations.log', values.toString);                                     
            return resultset;
          }
          // Call query function and echo results to console
          runQuery().then((resultset) => console.log(resultset.rows[0]));
          // TODO: Add this entry to the console log          
        });
      });
      lastFetchedDate = dateStr; // Set fetch date to current date 
        fs.appendFileSync('dataOperations.log', '\nLast fetched at ' + lastFetchedDate);       
        console.log('Latest fetch appended to the file', lastFetchedDate); 
         // TODO: Add this entry to the console log   

    } else {
      fs.appendFileSync('dataOperations.log', '\nData has been successfully retrieved earlier today');
      console.log('Retrieval message appended to the file');                 
    }
  } catch (error) {
    fs.appendFileSync('dataOperations.log', '\nAn error occurred');
    console.log('Error message appended to the file');    
    // TODO: Add this entry to the console log
  }
});