var express = require('express');
var router = express.Router();

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

const Cohort = require('../models/cohortSchema');
const Curriculum = require('../models/curriculumSchema');
const Course = require('../models/courseSchema');
const Schedule = require('../models/scheduleSchema');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/cohorts', async (req,res,next)=>{
  try{
    await Cohort.find({}, '', (err, cohort)=>{
      res.json(cohort);
    });
  }catch(e){
    res.send(e);
  }
});

router.post('/curriculum/:id', async (req,res,next)=>{
  try{
    if (typeof(req.params.id) == "undefined"){
      req.params.id = res.locals.curriculum
    }
    await Curriculum.findOne({'_id' : req.params.id}, '', (err, curr)=>{
      if(err) console.error(err);
      res.json(curr);
    });
  }catch(e){
    res.send(e);
  }
  
});

router.post('/course/:id', async (req,res,next)=>{
  
});

router.post('/schedule/:dept/:num', (req, res, next)=>{
  try{
     Schedule.findOne({ dept: req.params.dept, number: req.params.num}, '').then( (err, sch)=>{
      if(err){ console.log(err); }
      res.send(sch);
      console.log(`SCH: ${sch}`);
     } );
  }catch(e){
    console.log(`E : ${e}`);
  }finally{
    console.log("done")
  }
  
});


module.exports = router;
