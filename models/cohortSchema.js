const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//C Schema
const cohortSchema = new Schema({
    population: Number,
    quarter: Number,
    "start-date": String,
    curriculum: Schema.ObjectId
});

var Cohort = mongoose.model('Cohort', cohortSchema);

module.exports = Cohort;