const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//C Schema
const curriculumSchema = new Schema({
    name: String,
    quarters: Array,
    "start_date": String
});

var Curriculum = mongoose.model('Curriculum', curriculumSchema);

module.exports = Curriculum;