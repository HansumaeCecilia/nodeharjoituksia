const { transform, prettyPrint } = require('camaro');
const math = require('mathjs')
const axios = require('axios');

// Function to fetch wind speed and direction data and calculate a forecast
const calculateWindForecast = async (place) => {
    const url = `https://opendata.fmi.fi/wfs?service=WFS&version=2.0.0&request=getFeature&storedquery_id=fmi::observations::weather::hourly::multipointcoverage&place=${place}&parameters=WindDirection,WindSpeedMS`;

    try {
        const response = await fetch(url);
        const xmlData = await response.text(); // Get the XML response as text

        // Define your template for transforming XML to array of objects
        const template = [
            // ... Define your template structure based on the XML schema ...
            // Example: ['path/to/data', { key: 'xmlField' }],
        ];

        // Convert XML data to array of objects using the provided function
        const dataArray = await convertXml2array(xmlData, template);

        // Process the array of objects to extract wind direction and speed
        // (Assuming the structure of the dataArray)
        const observation = dataArray[0]; // Assuming the first observation
        const windDirection = observation.WindDirection;
        const windSpeed = observation.WindSpeedMS;

        // Calculate wind angle and speed using the provided function
        const windForecast = wind(windSpeed, windDirection);

        return windForecast;
    } catch (error) {
        console.error("Error fetching or processing data:", error);
        return null;
    }
};

// Example usage: Calculate wind forecast for a specific place (e.g., Turku)
calculateWindForecast('turku')
    .then((forecast) => {
        console.log('Wind Forecast:', forecast);
    })
    .catch((error) => {
        console.error('Error:', error);
    });
