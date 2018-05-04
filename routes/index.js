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
    res.render('index', {title: 'Cohort', cohort : cohort})
  });
});

router.get('/schedule/course/:id/curric/:cid', (req, res, next)=>{
  Course.find({ '_id':req.params.id }, '', (err, course)=>{
    Cohort.find({'_id' : req.params.cid}, '', (err, cohort)=>{
      res.render('index', {title: 'Schedule', cohort: cohort, course: course[0]});
    })
    
  });
});

module.exports = router;
