var me = document.querySelector('script[data-token="sch"]');
var dept = me.getAttribute('data-dept');
let num = me.getAttribute('data-num');

//Defining object to fetch everything you could need

/*
function Fetch(){
    this.cohorts = ()=>{
        
    };
}
*/

fetch(`/fetch/schedule/${dept}/${num}`, {
    method: 'POST',
}).then(res => {
    console.log(res);
    return res;
}).then( res=>res.json() ).then( ()=>{
    console.log(res);
} ).catch(e => {
    console.log(e);
});


$(".slider-range").slider({
    range: true,
    min: 420,
    max: 1240,
    step: 15,
    values: [540, 1020],
    slide: function (e, ui) {
        
        var hours1 = Math.floor(ui.values[0] / 60);
        var minutes1 = ui.values[0] - (hours1 * 60);

        if (hours1.length == 1) hours1 = '0' + hours1;
        if (minutes1.length == 1) minutes1 = '0' + minutes1;
        if (minutes1 == 0) minutes1 = '00';
        if (hours1 >= 12) {
            if (hours1 == 12) {
                hours1 = hours1;
                minutes1 = minutes1 + " PM";
            } else {
                hours1 = hours1 - 12;
                minutes1 = minutes1 + " PM";
            }
        } else {
            hours1 = hours1;
            minutes1 = minutes1 + " AM";
        }
        if (hours1 == 0) {
            hours1 = 12;
            minutes1 = minutes1;
        }



        $(this).parent().parent().find(`.slider-time`).html(hours1 + ':' + minutes1);
        $(this).parent().parent().find("input.start").val( $(this).parent().parent().find(`.slider-time`).text() );

        var hours2 = Math.floor(ui.values[1] / 60);
        var minutes2 = ui.values[1] - (hours2 * 60);

        if (hours2.length == 1) hours2 = '0' + hours2;
        if (minutes2.length == 1) minutes2 = '0' + minutes2;
        if (minutes2 == 0) minutes2 = '00';
        if (hours2 >= 12) {
            if (hours2 == 12) {
                hours2 = hours2;
                minutes2 = minutes2 + " PM";
            } else if (hours2 == 24) {
                hours2 = 11;
                minutes2 = "59 PM";
            } else {
                hours2 = hours2 - 12;
                minutes2 = minutes2 + " PM";
            }
        } else {
            hours2 = hours2;
            minutes2 = minutes2 + " AM";
        }

        $(this).parent().parent().find('.slider-time2').html(hours2 + ':' + minutes2);
        $(this).parent().parent().find("input.end").val( $(this).parent().parent().find(`.slider-time2`).text() );
    }
    
});



