const mathjs = require('mathjs')

// EXCERCISE 1

// Save data about person. 
// Choose which bits of information are mutable and which are constant, 
// and pick commands to define the variables.

const BDay = '10.12.1999'; // constant
const name1 = 'Jason'; // constant
let height = 176; //mutable
let weight = 62; // mutable
console.log(BDay, name1, height, weight);

const coder = new Map();
coder.set('fullname', 'Abby John');
coder.set('language', 'Python');
coder.set('preferredJob', 'backend');
coder.set('favDB', 'PostgreSQL');

class Coders {

    constructor(name, language, preferredJob, favDB){
        this.name = name
        this.language = language
        this.preferredJob = preferredJob
        this.database = favDB
    }   
}

const arrayOfCoders = [] // Empty list

const programmer1 = new Coders('Abby', 'Python,', 'backend', 'PostgreSQL');
arrayOfCoders.push(programmer1); // Add to array
const programmer2 = new Coders('Jason', 'C++,', 'frontend', 'SQLite');
arrayOfCoders.push(programmer2);
const programmer3 = new Coders('Nelly', 'JavaScript,', 'full stack', 'MySQL');
arrayOfCoders.push(programmer3);

console.log('Our coders are: ', arrayOfCoders);

class coderWithMethod {
    constructor(name, language, preferredJob, favDB){
        this.name = name
        this.language = language
        this.preferredJob = preferredJob
        this.database = favDB
    }

    calculateAverage(array){
        let sum = 0;
        let avg = 0;

        for (let index = 0; index < arrayOfCoders.length; index++) {
            const element = array[index];
            sum = sum + element
        }

        avg = sum / array.length;
        return avg;
    }
    variance(){
        const arrayVariance = mathjs.variance(this.array);
        const roundedArrayVariance = mathjs.round(arrayVariance, this.array);
        return roundedArrayVariance;
    }
}

const programmer4 = new coderWithMethod('Ollie', 'Python', 'full stack', 'SQLite');
console.log('Ollie\'s average is', programmer4.calculateAverage([4,3,5,2]));
console.log('Variance is', programmer4.variance([1,2,3,4]));

// function arrayStdDeviation(array) {
//     let sum = 0;
//     for (let index = 0; index < arrayOfCoders.length; index++){
//         const 
//     }
// }

// variance(){
//     const arrayVariance = mathjs.variance(this.array);
//     const roundedArrayVariance = mathjs.round(arrayVariance, this.array);
//     return roundedArrayVariance;
// }