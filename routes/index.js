var express = require('express');
var router = express.Router();

var quarter = require("../comp.js").getQuarter;
var current = require("../comp.js").getCurrent;

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

const Cohort = require('../models/cohortSchema');

router.get('/', (req,res,next)=>{
  res.render('index', {title: "NEIT IT"});
});

router.get('/cohorts/:id', (req,res,next)=>{
  Cohort.findOne({'_id' : req.params.id}, '', (err, cohort)=>{
    res.render('index', {title: 'Cohort', cohort : cohort})
  });
});

module.exports = router;
