const wind = (uVector, vVector) => {

    // Reset all values
    let windAngle = 0;
    let windSpeed = 0;
    let geographicAngle = 0;

    // atan2 returns angle in radians. Anrguments are in (y,x) order!
    let xyAngleRadian = Math.atan2(vVector, uVector);
    let xyAngleDegree = xyAngleRadian * 360 / (2 * Math.PI); // Convert radians into degrees

    // Convert x-y plane directions into geographic directions
    // There is a 90 degree shift between x-y and map directions
    if (xyAngleDegree > 90) {
        geographicAngle = 360 - (xyAngleDegree - 90);
    }

    else {
        geographicAngle = 90 - xyAngleDegree
    }

    if (geographicAngle < 180) {
        windAngle = geographicAngle + 180;
    }
    
    else {
        windAngle = geographicAngle -180
    }

    // Calculate wind speed according to the Pythagoras theorem
    windSpeed = Math.sqrt(uVector**2 + vVector**2);

    // Return all calculated parameters
    return {
        xyAngleRadian: xyAngleRadian,
        xyAngleDegree: xyAngleDegree,
        geographicAngle: geographicAngle,
        windAngle: windAngle,
        windSpeed: windSpeed
    };
}

console.log('u = 3, v = 4', wind(3, 4));
console.log('u = 3, v = -4', wind(3, -4))
console.log('u = -3, v = 4', wind(-3, 4))
console.log('u = -3, v = -4', wind(-3, -4))

// Important to test cases when a component is 0
console.log('u = 0, v = 4', wind(0, 4))
console.log('u = 4, v = 0', wind(4, 0))
console.log('u = 0, v = 0', wind(0, 0))