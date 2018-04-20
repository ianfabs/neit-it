fetch("http://localhost:3000/instructors").then( function(res){
          res = res.json();
          return res;
        }).then( function(res){
          for(i=0;i<res.length;i++){
            var li = document.createElement("li");
            var txt = document.createTextNode(`${res[i].instructorDisplayName}`);
            li.appendChild(txt);
            document.querySelector("#instructors").appendChild(li);
          }
        } );