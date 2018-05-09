var me = document.querySelector('script[data-token="curr"][data-quarter][data-id]');
var id = me.getAttribute('data-id');
let quarter = me.getAttribute('data-quarter');

if(id != 'undefined'){
    window.localStorage.curr = id;
    window.localStorage.quarter = quarter;

    window.localStorage.cohort = me.getAttribute('data-cohort')
}
const cohort = window.localStorage.cohort;

console.log(id);

    fetch(`/fetch/curriculum/${(window.localStorage.curr)}`, {
        method: 'POST',
        body: { q : Number(window.localStorage.quarter) }
    }).then(res => res.json()).then( (res)=>{
        
        let next = d.querySelector("#nextCourses");
        let curric = d.querySelector("#curric");
        curric.appendChild( document.createTextNode(`Quarter ${window.localStorage.quarter} of ${res.name}`) );
        console.log(res.quarters);
        index = window.localStorage.quarter;
        
        for(course in res.quarters[index]){
            course = res.quarters[index][course];
            let li = d.createElement('li'), a = d.createElement("a");
            let txt = d.createTextNode(`${course.dept}${course.number}`);
            a.href=`/schedule/course/${course._id}/curric/${window.localStorage.curr}`;
            a.appendChild(txt);
            li.appendChild(a);
            next.appendChild(li);
            
        }
        d.querySelector('.selectCourse').appendChild(selectCourse);
    } ).catch( (e)=>{
        console.log("An error has occured");
    } );

