// EXCERCISE 1

// Save data about person. 
// Choose which bits of information are mutable and which are constant, 
// and pick commands to define the variables.

const BDay = '10.12.1999';
const name1 = 'Jason';   
let height = 176;
let weight = 62;
console.log(BDay, name1, height, weight);

// EXCERCISE 2

// Use object key-value pairs to save person data.

const coderData = {
    name: 'Abby',
    language: 'python',
    orientation: 'front-end',
    favDBase: 'SQL'
};
    //console.log(coderData);

const coder2Data = {
    name: 'Dan',
    language: 'C',
    orientation: 'front-end',
    favDBase: 'SQL'
};
    //console.log(coder2Data);

const coder3Data = {
    name: 'Nelly',
    language: 'C++',
    orientation: 'back-end',
    favDBase: 'SQL'
};

// EXCERCISE 3

// Save data of multiple people to a variable.

const people = new Set();
people.add(coderData);
people.add(coder2Data);
people.add(coder3Data);
console.log(people);