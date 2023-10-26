const Pool = require('pg').Pool;
const cron = require('node-cron');
const getPrices = require('./getNewPrices')
const fs = require('fs');
const logger = require('./logger')

const pool = new Pool({
  user: 'postgres', // In production always create a new user for the app
  password: 'Q2werty',
  host: 'localhost', // localhost or 127.0.0.1 if in the same computer, otherwise IP
  database: 'smarthome',
  port: 5432
});

let lastFetchedDate = '1.1.2023';
let message = ''
const logFile = 'dataOperations.log'

cron.schedule('* * * * * *', () => {
  try {
    let timestamp = new Date(); // Get the current timestamp
    let dateStr = timestamp.toLocaleDateString(); // Take date part of the timestamp

    // If the date of last successful fetch is not the current day, fetch data
    if (lastFetchedDate != dateStr) {
      message = 'Started fetching price data'

      // Log event to  console and log file
      console.log(message);
      logger.add2log(message, logFile)
      getPrices.fetchLatestPriceData().then((json) => {

        // Loop through prices data and pick startDate and price elements
        json.prices.forEach(async (element) => {
          let values = [element.startDate, element.price];

          // Build a SQL clauset to insert values into table
          const sqlClause = 'INSERT INTO public.hourly_price (timeslot, price) VALUES ($1, $2) ON CONFLICT DO NOTHING RETURNING *';

          // Function for running SQL operations asyncronously
          const runQuery = async () => {
            let resultset = await pool.query(sqlClause, values);
            return resultset;
          }
          // Call query function
          runQuery().then((resultset) => {

            // If there is alredy a price for thetimeslot, row is empty ie. undefined
            if (resultset.rows[0] != undefined) {
              message = 'Added a row' // The message when not undefined
            }
            else {
              message = 'Skipped an existing row' // The message when undefined
            }

            // Log the result of insert operation
            console.log(message);
            logger.add2log(message, logFile)

          })

        });
      });
      lastFetchedDate = dateStr; // Set fetch date to current date

      // Log when last fetched
      message = 'Fetched at ' + lastFetchedDate;
      console.log(message)
      logger.add2log(message, logFile)
    } else {

      // Log if data has been retrieved earlier at the same day
      message = 'Next scheduled event: Data has been successfully retrieved earlier today'
      console.log(message);
      logger.add2log(message, logFile)
    }

    // Log an error if something has been failed to run
  } catch (error) {
    message = 'An error occurred (' + error.toString() + '), trying again in 5 minutes until 4 PM';
    console.log(message)
    logger.add2log(message, logFile)
  }
});