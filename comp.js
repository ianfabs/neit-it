exports.getQuarter = function(start, current){
    // The starting date represents quarter one
    // the first four numbers are the year that the academic year will end in
    // the last two are the current quarter season
    // example 201810 is Fall of 2017
    // 201820 is Winter 2017-2018
    // 201830 is Spring 2018
    // 201840 is Summer 2018
    // 201910 is Fall 2018
    //@param `start` = String()
    //@param `current` = String()
    start = String(start);
    current = String(current);
    let a = [start.slice(0,4) , start.slice(4)/10];
    let b = [current.slice(0,4), current.slice(4)/10];
    let q = 1;
    if( Math.abs(a[0] - b[0]) == 1){
        //a year has progressed
        //so, knowing that they started at quarter 1 at `start`,
        //they must be in quarter 5
        // (4 quarters is one academic year)
        q += (4 * Math.abs(a[0] - b[0]) );
    }else if(Math.abs(a[0] - b[0]) == 0){
        //same academic year, so do nothing
        
    }

    //201810
    //201830
    // = +2 quarters
    q += Math.abs(a[1] - b[1]);
    
    return q;
};

exports.getCurrent = function(){
    let y = new Date().getFullYear();
    let m = new Date().getMonth();
    let d = new Date().getDate();
    let s;

    if( (m == 9 && d >= 2 && d <= 31) || (m == 10 && d >= 1 && d <= 30 ) || (m == 11 && d>=1 && d <= 16) ){
        //Fall Quarter
        s = 10;
    }
    if( (m == 0 && d >= 7 && d <= 31) || (m == 1 && d >= 1 && d <= 28 ) || (m == 2 && d>=1 && d <= 17) ){
        //Winter Quarter
        s = 20;
    }
    if( (m == 2 && d >= 25 && d <= 31) || (m == 3 && d >= 1 && d <= 30 ) || (m == 4 && d>=1 && d <= 31) || (m == 5 && d>=1 && d <= 2) ){
        //Spring Quarter
        s = 30;
    }
    if( (m == 6 && d >= 15 && d <= 31) || (m == 7 && d >= 1 && d <= 31 ) || (m == 8 && d>=1 && d <= 22) ){
        //Summer Quarter
        s = 40;
    }

    return String("".concat(y,s));
}