ready(()=>{
    fetch('/fetch/cohorts', {method:'POST'}).then(res => res.json()).then( (res)=>{
        let cohorts = document.querySelector("#cohorts");
        //console.log(res);
        for(el in res){
            el = res[el];
            let cohort = document.createElement("div");
            cohort.classList.add("cohort");
            let left = document.createElement("span"), a = document.createElement("a");
                left.classList.add("left");
            let right = document.createElement("span");
                right.classList.add("right");
            let txt1 = document.createTextNode(`Session ${el.session}, Q${el.quarter}, ${el.section}, ${el.population} students`);
            if(el.active){
                right.appendChild( document.createTextNode("\u2015") );
            }else{
                right.appendChild( document.createTextNode("\u2713") )
            }
            a.appendChild( txt1 );
            a.setAttribute("href", `/cohorts/${el._id}`);
            left.appendChild(a);
            cohort.appendChild(left);
            
            cohort.appendChild(right);
            
            cohorts.appendChild(cohort);
        }
        console.log(cohorts);
        
    } );
});
