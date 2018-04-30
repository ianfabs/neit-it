var me = document.querySelector('script[data-token="curr"][data-quarter][data-id]');
var id = me.getAttribute('data-id');
let quarter = me.getAttribute('data-quarter');
console.log(id);

    fetch(`/fetch/curriculum/${id}`, {method: 'POST'}).then(res => res.json()).then( (res)=>{
        
        let next = document.querySelector("#nextCourses");
        let curric = document.querySelector("#curric");
        curric.appendChild( document.createTextNode(`Quarter ${quarter} of ${res.name}`) );
        console.log(res.quarters);
        index = quarter;

        for(course in res.quarters[index]){
            course = res.quarters[index][course];
            let li = document.createElement('li');
            let txt = document.createTextNode(`${course.dept}${course.number}`);
            li.appendChild(txt);
            next.appendChild(li);
        }
    } );