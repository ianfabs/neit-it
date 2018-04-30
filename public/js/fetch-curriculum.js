var me = document.querySelector('script[data-token="curr"][data-quarter][data-id]');
var id = me.getAttribute('data-id');
var quarter = me.getAttribute('data-quarter');
console.log(id);

    fetch(`/fetch/curriculum/${id}`, {method: 'POST'}).then(res => res.json()).then( (res)=>{
        let current = document.querySelector("#currentCourses");
        let next = document.querySelector("#nextCourses");
        let curric = document.querySelector("#curric");
        curric.appendChild( document.createTextNode(`${res.name}`) );
        console.log(res.quarters);
        index = quarter-1;
        for(course in res.quarters[index]){
            course = res.quarters[index][course];
            let li = document.createElement('li');
            let txt = document.createTextNode(`${course.dept}${course.number}`);
            li.appendChild(txt);
            current.appendChild(li);
        }

        for(course in res.quarters[index+1]){
            course = res.quarters[index+1][course];
            let li = document.createElement('li');
            let txt = document.createTextNode(`${course.dept}${course.number}`);
            li.appendChild(txt);
            next.appendChild(li);
        }
    } );