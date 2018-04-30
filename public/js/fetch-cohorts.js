fetch('/fetch/cohorts', {method:'POST'}).then(res => res.json()).then( (res)=>{
    let cohorts = document.querySelector("#cohorts");
    
    //console.log(res);
    for(el in res){
        el = res[el];
        let li = document.createElement("li"), a = document.createElement("a");
        let txt = document.createTextNode(`${el["start-date"]} - ${el.population} students`);
        a.appendChild( txt );
        a.setAttribute("href", `/cohorts/${el._id}`);
        //console.log("test: [i]: " + res[el].quarter);
        li.appendChild(a);
        cohorts.appendChild(li);
    }
    console.log(cohorts);
    
} );