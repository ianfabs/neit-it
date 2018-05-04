var express = require('express');
var router = express.Router();

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

const Cohort = require('../models/cohortSchema');
const Curriculum = require('../models/curriculumSchema');
const Course = require('../models/courseSchema');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/cohorts', (req,res,next)=>{
  Cohort.find({}, '', (err, cohort)=>{
    res.json(cohort);
  });
});

router.post('/curriculum/:id', (req,res,next)=>{
  if (typeof(req.params.id) == "undefined"){
    req.params.id = res.locals.curriculum
  }
  Curriculum.findOne({'_id' : req.params.id}, '', (err, curr)=>{
    if(err) console.error(err);
    res.json(curr);
  });
});

router.post('/course/:id', async (req,res,next)=>{
  
});


module.exports = router;
