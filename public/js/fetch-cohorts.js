fetch("http://localhost:3000/cohorts").then( function(res){
          res = res.json();
          return res;
        }).then( function(res){
          for(i=0;i<res.length;i++){
            var li = document.createElement("li");
            var a = document.createElement("a");
            a.setAttribute('href', `/cohorts/${res[i].id}`);
            var txt = document.createTextNode(`Quarter ${res[i].q} - ${res[i].CohortStudentCount} students`);
            a.appendChild(txt);
            li.appendChild(a);
            document.querySelector("#cohorts").appendChild(li);
          }
        } );