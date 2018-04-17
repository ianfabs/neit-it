$(document).ready( ()=>{
    fetch("http://localhost:3000/courses").then( function(res){
      res = res.json();
      return res;
    }).then( function(res){
      for(i=0;i<res.length;i++){
        var li = document.createElement("li");
        var txt = document.createTextNode(`${res[i].CourseDept} ${res[i].CourseID} ${res[i].CourseTitle}`);
        li.appendChild(txt);
        document.querySelector("#courses").appendChild(li);
      }
    } );
} );