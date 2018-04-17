$(document).ready( ()=>{
    $(".cbox").hide();
    $(".cbox.one").show();

    $("span.tab").click(function(){
        $(".tab").removeClass("active");
        $(this).toggleClass("active");
        var number = $(this).attr("class").slice( $(this).attr("class").indexOf("tab")+4, $(this).attr("class").indexOf("active")-1);

        

        if($(this).hasClass("active")){
            $(".cbox").hide();
            $(`.cbox.${number}`).show();
        }
    });
} );