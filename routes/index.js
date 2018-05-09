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
  try{
    res.render('index', {title: "NEIT IT"});
  }
  catch(e){
    res.status(69).send("An error has occured");
  }
});

router.get('/cohorts/:id', async (req,res,next)=>{
  res.locals.cohort = req.params.id;
  try{
    await Cohort.findOne({'_id' : req.params.id}, '', (err, cohort)=>{
      res.render('index', {title: 'Cohort', cohort : cohort})
    });
  }catch(e){
    res.send("An internal error has occured");
  }
  
});

router.get('/schedule/course/:id/curric/:cid', async (req, res, next)=>{
  try{
    Course.find({ '_id':req.params.id }, '', (err, course)=>{
      Cohort.find({'_id' : req.params.cid}, '', (err, cohort)=>{
        res.render('index', {title: 'Schedule', cohort: cohort, course: course[0]});
      })
    });
  }catch(e){
    res.send(e);
  }
  
});

module.exports = router;
