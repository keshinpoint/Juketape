$(document).ready(function () {
    $('.navbar-brand').click(function (event) {
        event.preventDefault();
        event.stopPropagation();
        location.reload(true);
        $(document).scrollTop(0);
        

    });
});

$(document).ready(function () {
    $(".About a").click(function (event) {
        event.preventDefault();
        event.stopPropagation();
        $('html, body').animate({
            scrollTop: $("#About-content").offset().top -120
        }, 600);
    });
});


$(document).ready(function () {
    $(".How-it-works a").click(function () {
        event.preventDefault();
        event.stopPropagation();
        $('html, body').animate({
            scrollTop: $("#howto").offset().top - 120
        }, 600);
    });
});

$(document).ready(function () {

  
        $('.password').on('keyup', '.passwrdforsignup', function () {
            var getPW =  $(this).get(0);
            getPW.setCustomValidity("");
            if (getPW.checkValidity() === false) {
                getPW.setCustomValidity("Passwords must be atleast six characters long with one number");
                
            }
        });
});

 


  