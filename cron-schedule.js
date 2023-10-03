import fetch from 'node-fetch';
import cron from 'node-cron';

const PRICE_ENDPOINT = 'https://api.porssisahko.net/v1/price.json';

cron.schedule('30 15 * * *', () => {
    // console.log('Daily execution at 15:30')
},);

const response = await fetch(`${PRICE_ENDPOINT}`);
const { price } = await response.json();

console.log(`Daily execution at 15:30 ${price}`);