var express = require('express');
var router = express.Router();

var quarter = require("../comp.js").getQuarter;
var current = require("../comp.js").getCurrent;

const mongodb = require('mongodb');
const mongoose = require('mongoose');

mongoose.connect('mongodb://localhost/neit');

router.get('/', (req,res,next)=>{
  res.render('index', {title: "NEIT IT"});
})

module.exports = router;
