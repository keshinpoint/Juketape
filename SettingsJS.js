$(document).ready(function () {
    $(window).scroll(function () {
    var div_one_top = $('#Profile-settings').offset().top; //offset() gives the position relative to the next direction fiven (here it's top). position() gives position relative to parent class
    var div_two_top = $('#social-settings').offset().top;
    
        var scroll_top = $(window).scrollTop();
   

        if(scroll_top > div_one_top && scroll_top < div_two_top) {
            //You are now past div one
            if ($('a[href="#Profile-settings"]').hasClass('active')) {
                $('a[href="#Profile-settings"]').addClass('active');
            }
            if ( $('a[href="#social-settings"]').hasClass('active')) {
                $('a[href="#social-settings"]').removeClass('active');
            }
            
        } 
        
        else if (scroll_top > div_two_top) {


            if ($('a[href="#Profile-settings"]').hasClass('active')) {
                $('a[href="#Profile-settings"]').removeClass('active');
            }

            if ($('a[href="#social-settings"]').hasClass('active')) {
                $('a[href="#social-settings"]').addClass('active');


            }
        }
    });

});


$(document).ready(function () {
    $("#sidebar-id").on('click', ".profile-sidebar", function (e) {
        $('html, body').animate({ scrollTop: 0 }, 400);
        e.preventDefault();
        e.stopPropagation();
    });

    $("#sidebar-id").on('click', ".social-sidebar", function (e) {
        $('html, body').animate({ scrollTop: $('#social-settings').offset().top }, 400);
        e.preventDefault();
        e.stopPropagation();
    });
});

$(document).ready(function () {

    $('.navbar-brand').click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        location.reload(true);
        $(document).scrollTop(0);

    });

});


$(document).ready(function () {

    $('#new-pw').on('keyup', function () {
        var newPW = $(this).get(0); //This gets the element that is being entered
        newPW.setCustomValidity("");

        if (newPW.checkValidity() === false) {

            newPW.setCustomValidity("Passwords must be atleast six characters long with one number");

        }


    });

});


$(document).ready(function () { //This confirms if the 2 passwords match   

    $('#f').on('keyup', '.cnfrm-pw', function (e) {
         
        var pwd1 = document.getElementById("new-pw").value;
        var pwd2 = document.getElementById("cnfrm-pw").value;

        if (pwd1 != pwd2) {
            document.getElementById("cnfrm-pw").setCustomValidity("The passwords don't match"); //The document.getElementById("cnfrm-pw") selects the id, not the value
        }

        else {
            document.getElementById("cnfrm-pw").setCustomValidity("");
            //empty string means no validation error        
        }
        e.preventDefault();  //would still work if this wasn't present
    }

    );

});

$(document).ready(function () {  //Counts the number of characters in the about me box
    $('#field').keyup(function () {
        var charlength = $(this).val(); //*val() and value are different
        $('#char-num').text(charlength.length);

    });

});