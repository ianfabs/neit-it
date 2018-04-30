var express = require('express');
var router = express.Router();

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

const Cohort = require('../models/cohortSchema');
const Curriculum = require('../models/curriculumSchema');

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
  Curriculum.findOne({'_id' : req.params.id}, '', (err, curr)=>{
    res.json(curr);
  });
});

module.exports = router;
