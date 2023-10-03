
const fs = require('fs');

const addLogEntry = (entry, fileName) => {
    const isoTimeStamp = new Date().toISOString();
    const logRow = entry + '@' + isoTimeStamp
    fs.appendFile(fileName, logRow, (err) => {
        if (err) {
            console.log(err);
        }
    })
};

// Testing add2log function
addLogEntry('dataOperations.log', '\nTest message');

// EXPORT
// ------

module.exports = {
    addLogEntry
}

 