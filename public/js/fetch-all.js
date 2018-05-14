var me = document.querySelector('script[data-token="sch"][data-quarter][data-id]');
var id = me.getAttribute('data-id');
let quarter = me.getAttribute('data-quarter');

//Defining object to fetch everything you could need

/*
function Fetch(){
    this.cohorts = ()=>{
        
    };
}
*/

fetch(`/fetch/schedule/${}/${}`)