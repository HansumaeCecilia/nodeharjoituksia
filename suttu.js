const axios = require('axios');
const { transform, prettyPrint } = require('camaro');

let config = {
  method: 'get',
  maxBodyLength: Infinity,
  url: 'https://opendata.fmi.fi/wfs/fin?service=WFS&version=2.0.0&request=GetFeature&storedquery_id=fmi::observations::weather::timevaluepair&place=turku&parameters=t2m,ws_10min',
  headers: { }
};

axios.request(config)
.then((response) => {
  console.log(response.data);
})
.catch((error) => {
  console.log(error);
});

// const temperatureTemplate = [
//     'wfs:FeatureCollection/wfs:member/omso:PointTimeSeriesObservation/om:result/wml2:MeasurementTimeseries/wml2:point/wml2:MeasurementTVP',
//     {
//       timeStamp: 'wml2:time',
//       temperature: 'number(wml2:value)',
//     },
//   ];