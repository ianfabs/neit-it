/*JavaScript Globals library*/
/*
    A library created by @ianfabs to provide some decent javascript shortcuts

    @param {function} ready;
    @param {object}   d;
    @param {function} ac;
*/

const ready = function(fn) {
    if (document.attachEvent ? document.readyState === "complete" : document.readyState !== "loading"){
      fn();
    } else {
      document.addEventListener('DOMContentLoaded', fn);
    }
  }
const d = document;