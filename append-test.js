

const fs = require('fs');

var data = "\n\nAdd this line to the file.";
// append data to file
fs.appendFileSync('sample.txt', data, 'utf8');
console.log("Data is appended to file successfully.")