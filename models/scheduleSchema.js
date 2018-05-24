const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//S Schema
const scheduleSchema = new Schema({
    dept: String,
    number: String,
    times: Array,
    room: Schema.ObjectId,
    cohort: Schema.ObjectId,
    quarter: Number,
    curriculum: Schema.ObjectId,
    instructor: Schema.ObjectId,
    section: Number,
    session: Number
});

const Schedule = mongoose.model('Schedule', scheduleSchema);

module.exports = Schedule;