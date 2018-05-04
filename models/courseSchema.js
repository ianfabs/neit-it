const mongoose = require('mongoose');
const Schema = mongoose.Schema;

//C Schema
const courseSchema = new Schema({
    name : String,
    dept : String,
    number: Number,
    quarter: Number,
    hours: Number,
    curriculum: Number
});

var Course = mongoose.model('Course', courseSchema);
module.exports = Course;
/*
Course.find( {
      $or : [
        {
          dept: {
            $all : bs1
          }
        },
        {
          number: {
            $all : bs2
          }
        }
      ]
    } );
*/