//route for /cohort
var express = require('express');
var router = express.Router();

var quarter = require("../comp.js").getQuarter;
var current = require("../comp.js").getCurrent;

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

const Cohort = require('../models/cohortSchema');
const Course = require('../models/courseSchema');

router.get('/', (req,res,next)=>{
  res.render('index', {title: "NEIT IT"});
});

router.get('/cohorts/:id', (req,res,next)=>{
  res.locals.cohort = req.params.id;

  Cohort.findOne({'_id' : req.params.id}, '', (err, cohort)=>{
    res.locals.curriculum = cohort.curriculum;
    res.render('index', {title: 'Cohort', cohort : cohort})
  });
});

router.get('/schedule/course/:id', (req, res, next)=>{
    console.log(res.locals.curriculum);
  Course.find({ '_id':req.params.id }, '', (err, course)=>{
    Cohort.find({'_id' : res.locals.cohort}, '', (err, cohort)=>{
      res.render('index', {title: 'Schedule', course: course[0], cohort: cohort});
    })
    
  });
});

module.exports = router;
