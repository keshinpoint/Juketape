// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require best_in_place
//= require jquery-ui/datepicker
//= require best_in_place.jquery-ui
//= require bootstrap/bootstrap-tooltip
//= require local_time
//= require_tree .


// forcing page to 80%

//landing page password validity 

$(document).ready(function () {

  $('.password-main').on('keyup', function () {
    var newPW = $(this).get(0); 
    newPW.setCustomValidity("");

    if (newPW.checkValidity() === false) {

      newPW.setCustomValidity("Passwords must be atleast six characters long with one number");

    }


  });

});

//setting min height of search result and the dashfolio contents

$(document).on('turbolinks:load',function() {
  function setHeight() {
    windowHeight = $(window).innerHeight();
    $('.content_body').css('min-height', windowHeight);
  
  };
  setHeight();
  
  $(window).resize(function() {
    setHeight();
  });
});

//setting the border of the dashfolio content to the end of the browser window
$(document).ready(function(){
  var height_from_top = $('.dashfolio-main-row').offset.top; //gets height of the main row from the top
  console.log(height_from_top);

  var windowHeight = $(window).innerHeight(); //gets height of entire window
  console.log(windowHeight);

  var elementHeight = $('.dashfolio-content-dashbar').height(); //gets height of the midbar
  console.log(elementHeight);

  var height_from_bottom = windowHeight - height_from_top + elementHeight;
  console.log(height_from_bottom);

  $('.dashfolio-main-container').css('min-height', height_from_bottom);

});


//making the midbar sticky and fixed on scroll

$(document).ready( function() {

  $(window).scroll( function() {
    if (($('#dashfolio-main-row').length > 0) && $(window).scrollTop() > $('#dashfolio-main-row').offset().top)
      $('.dashfolio-content-dashbar').addClass('sticky');         
    else
      $('.dashfolio-content-dashbar').removeClass('sticky');
  } );

} );


$(document).on('turbolinks:load', function() {
  $('.nav-notif-counter').css({ opacity: 0 }).animate({ top: '-1px', opacity: 1 }, 500);

});



$(document).on('turbolinks:load', function() {
  $(function() {
    $('.best_in_place').best_in_place();
    $('.datepicker_input').datepicker({
      dateFormat: "dd/mm/yy"
    });
    $('[data-toggle="tooltip"]').tooltip();
    if ($('.inbox-main-message-body').length > 0) {
      $(".inbox-main-message-body").scrollTop($('.inbox-main-message-body')[0].scrollHeight);
    };
    $('.pagination > a').attr('data-remote', 'true');
  });

  $('form.dashfolio-timeline-form').on('ajax:error', function(jqXHR, error) {
    var $errorObj = $('form.dashfolio-timeline-form .errors');
    $errorObj.html(error.responseText);
  });

  $('.event_end_date_checkbox').on('change', function() {
    $(this).closest('form').find('.timeline-form-end-date').prop('disabled', function(i, v) { return !v; });
  });

  $('.my_dashfolio .timeline-date').on('click', function() {
    $(this).hide().siblings('.timeline-date-edit').slideDown();
  })

  $('.timeline-event-date-cancel').on('click', function() {
    $(this).parents('.timeline-date-edit').hide().siblings('.timeline-date').show();
  });

  $('.timeline-event-add').on('click', function(){
    $('.timeline-form-panel').slideDown();
    $('.timeline-event-cancel').show();
  })

  $('.timeline-event-cancel, #timeline-event-cancel').on('click', function(){
    $('.timeline-form-panel').slideUp();
    $('.timeline-event-cancel').hide();
  });

  $('#filterContentModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    var location = button.data('url');
    var content_type = button.data('content');
    var container = button.data('container');
    var $modal = $(this);
    $modal.find('.modal-title').text('Filter Content');
    $modal.find('.modal-body').html('<a href="#" class="btn btn-info disabled" role="button">Loading...</a>');
    $modal.find('.modal-footer').html('<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>');
    $.ajax({
      method: 'GET',
      url: location,
      data: { content_type: content_type, container: container }
    }).done(function(resp) {
      $modal.find('.modal-content').html(resp);
      $('.sync_with_networks input[type=checkbox]').on('change', function() {
        if($(this).prop('checked') == true) {
          $('input[name="selected_items[]"]').prop("checked", true);
        }
      });
    });

  }); //end of $('#filterContentModal')

  $('#add_tag_form')
  .on('ajax:success', function(data, jqXHR) {
    $('#add-tag-input').val('');
    $('#tag-container .tags-list').append(jqXHR.content);
    console.log(jqXHR.content);
    if(jqXHR.tags_count >= 5) {
      $('#add-tag-input-group').hide();
      $('#add-tag-input').hide();
    }

  }).on('ajax:error', function(jqXHR, error) {
    console.log('Its Error')
  });

  // Adding emails in the invite page
  $('#add-email-button').on('click', function (e) {
    e.preventDefault();
    if($('.invite_users_container .email_holder').length >= 5) {
      return false;
    }
    var location = $(this).data('url');
    var userEmail = $('#input_user_email').val();
    $('.invite_users_container .errors').text('');
    if(userEmail == "") {
      $('.invite_users_container .errors').text('Please enter email address');
      return;
    }
    $(this).addClass("disabled");
    $.ajax({
      method: 'GET',
      url: location,
      data: { email: userEmail }
    }).done(function(resp) {
      if(resp.user_act_name == null) {
        $("#input_user_email").val('');
        $('.invite_users_container .emails_list').append('<div class="email_holder"><span class="email-tag"><span class="email">' + userEmail + '</span><span class="close">x</span></span></div>');
        $('#send_invitations').removeAttr('disabled');
        if($('.invite_users_container .email_holder').length >= 5) {
          $('#add-email-button').attr('disabled', 'disabled');
        }
        removeEmailOnClose();
      } else {
        $('.invite_users_container .errors').text('User already existed with the given Email, please give some other email')
      }
      $('#add-email-button').removeClass("disabled");
    });
  }); //end of $('#add-email-button')

  var removeEmailOnClose = function() {
    $('.email-tag .close').on('click', function(){
      $(this).parents('.email_holder').remove();
      $('#add-email-button').removeAttr('disabled');
      if($('.invite_users_container .email_holder').length == 0) {
        $('#send_invitations').attr('disabled', 'disabled');
      }
    });
  };

  $('#send_invitations').on('click', function(){
    var $emails = $('.invite_users_container .emails_list .email');
    var emails = []
    for(var i=0; i<$emails.length; i++) {
      emails.push($emails[i].textContent);
    }
    if(emails.length == 0)
      return;

    $(this).addClass("disabled");
    $.ajax({
      method: 'POST',
      url: '/invitations/send_invitations',
      type: 'HTML',
      data: { emails: emails}
    })
  });
});

// Below is the javascript for static pages
$(document).on('turbolinks:load', function() {
  $('#add-tag-form-button').on('click', function(){
    $('#add-tag-input-group').show();
    $(this).hide();
  });

  $('#cancel-tag-form-button').on('click', function(){
    $('#add-tag-input-group').hide();
    $('#add-tag-form-button').show();
  });


//js for tags


$('.dashfolio-midbar-about a').on('click', function(e){
  var currentAttrValue1 = $(this).attr('href');   

    //below adds the active styles to midbar navigation icons
    $(this).parent().parent().addClass("dashfolio-midbar-active").siblings().removeClass("dashfolio-midbar-active");
    //

    $('.dashfolio-about').show()
    $('.main-content ' + currentAttrValue1).fadeIn(400);		
    $('.dashfolio-music').hide();
    $('.dashfolio-video').hide();
    $('.dashfolio-pictures').hide();
    e.preventDefault();      
    e.stopPropagation();

  });

$('.dashfolio-midbar-music a').on('click', function(e){
  var currentAttrValue2 = $(this).attr('href');


    //below adds the active styles to midbar navigation icons
    $(this).parent().parent().addClass("dashfolio-midbar-active").siblings().removeClass("dashfolio-midbar-active");
    //

    $('.dashfolio-music').show();
    
    $('.main-content ' + currentAttrValue2).fadeIn(400);
    $('.dashfolio-about').hide();
    $('.dashfolio-video').hide();
    $('.dashfolio-pictures').hide();
    e.preventDefault();
    e.stopPropagation();		
  });

//this below sees to it that the individal trackscontainer under the music tab is active by default only on the first click
$('.dashfolio-midbar-music a').one('click', function(e){
  $('#tracks-dashfolio').show();  
  $('.dashfolio-album-add-container').hide();	
});

$('.dashfolio-midbar-videos a').on('click', function(e){
 var currentAttrValue3 = $(this).attr('href');


    //below adds the active styles to midbar navigation icons
    $(this).parent().parent().addClass("dashfolio-midbar-active").siblings().removeClass("dashfolio-midbar-active");
    //

    $('.dashfolio-video').show();
    $('.main-content ' + currentAttrValue3).fadeIn(400);
    $('.dashfolio-music').hide();
    $('.dashfolio-about').hide();
    $('.dashfolio-pictures').hide();
    e.preventDefault();
    e.stopPropagation();
  });

$('.dashfolio-midbar-pictures a').on('click', function(e){
 var currentAttrValue4 = $(this).attr('href');


    //below adds the active styles to midbar navigation icons
    $(this).parent().parent().addClass("dashfolio-midbar-active").siblings().removeClass("dashfolio-midbar-active");
    //

    $('.dashfolio-pictures').show();
    $('.main-content ' + currentAttrValue4).fadeIn(400);
    $('.dashfolio-music').hide();
    $('.dashfolio-about').hide();
    $('.dashfolio-video').hide();
    e.preventDefault();	
    e.stopPropagation();
  });

});


$(document).on('turbolinks:load', function(){


  $('.music-header-container a').on('click', function(e){

    var attribute_tabcontent_music = $(this).attr('href');
    $('.music-content ' + attribute_tabcontent_music).fadeIn(400).siblings().hide();
    $(this).addClass("music-header-container-active");
    $(this).parent().siblings().find(".tablink").removeClass("music-header-container-active");
    $('.dashfolio-about').hide();
    $('.dashfolio-video').hide();
    $('.dashfolio-pictures').hide();



    e.preventDefault(); 
    e.stopPropagation();


  });

  $('.tracks-header').on('click', function() {
    $('.dashfolio-tracks-add-container').show();
    $('.dashfolio-album-add-container').hide();

  });

  $('.album-header').on('click', function() {
    $('.dashfolio-tracks-add-container').hide();
    $('.dashfolio-album-add-container').show();
  });

 

  $('.about-header-container-col a').on('click', function(e){

    var attribute_tabcontent_about = $(this).attr('href');
    $('.about-content ' + attribute_tabcontent_about).fadeIn(400).siblings().hide();

    $(this).addClass("about-header-container-active");
    $(this).parent().siblings().find(".tablink").removeClass("about-header-container-active");
    $('.dashfolio-music').hide();
    $('.dashfolio-video').hide();
    $('.dashfolio-pictures').hide();
    e.preventDefault();
    e.stopPropagation();
  });

});



//conenction request invite 

$(document).on('turbolinks:load', function() {

// first we take care of the friend radio button, since that's checked by default and we need to make sure
// the  $('input[type=radio]').change(function() only gets triggeed when the radio buttons are clicked o changed
// since the friend radio is clicked by default, that wont get triggered, and I had to create them again just for that
     function updateCountdown() {

      var char_limit = 300;
      var remaining = char_limit - $('.invite-message').val().length;
      var char_counter = $('.invite-friend-counter');
      char_counter.text(remaining);
   

    }
    

    $(".invite-message-friend").prop('maxLength', 300); //enforce max length as 300 for invite messages
    updateCountdown();
    $('.invite-message-friend').val("I would like to add you to my creative network on Juketape.");
    $('.invite-message-friend').focus(updateCountdown);
    $('.invite-message-friend').change(updateCountdown);
    $('.invite-message-friend').keyup(updateCountdown);

    
	
  $('input[type=radio]').change(function() {
    if ($('.invite-radio').is(':checked')) {
      var invite_forms = $('.invite-form'); //hides all the invite form messages paremt divs first
      invite_forms.hide().children().prop('disabled', true); //just in case, disables the form messages
      var next_form = $(this).parent().parent().next('.invite-form'); //the radio button  is $(this), its parent is the label
      //contd.frm above; the labels parent is the radio button div. The next sibling is the form field for the message  
      next_form.show();
      next_form.find('.invite-message').prop('disabled', false); //enabling the form field
      next_form.find('.invite-message').val("I would like to add you to my creative network on Juketape.");

    }

    function updateCountdown() {

      var char_limit = 300;
      var remaining = char_limit - next_form.find('.invite-message').val().length;
      var char_counter = next_form.find('.invite-char-counter');
      char_counter.text(remaining);
   

    }

    $(".invite-message").prop('maxLength', 300); //enforce max length as 300 for invite messages
    updateCountdown();
    $('.invite-message').change(updateCountdown);
    $('.invite-message').keyup(updateCountdown);

  });




});


//search navigation JS

$(document).on('turbolinks:load', function() {

  $('.search-navigation').on('click', function(e){ 
    $(this).addClass("search-navigation-active");
    $(this).siblings().removeClass("search-navigation-active");

    $(this).find("p").addClass("search-navigation-p-active");
    $(this).siblings().children("p").removeClass("search-navigation-p-active");

    $(this).find("span").addClass("search-number-active").removeClass("search-number-inactive");   
    $(this).siblings().find(".search-number").removeClass("search-number-active").addClass("search-number-inactive");

    $(this).find("span").addClass("search-number-active");
    $(this).find("span").removeClass("search-number-inactive");
    $(this).siblings().children("span").removeClass("search-number-active");
    $(this).siblings().children("span").addClass("search-number-inactive");

    var container = $(this).data('container');
    $('.' + container).show().siblings().hide();
    e.preventDefault();
  });


});


// settings navigation js

$(document).on('turbolinks:load', function() {
  $('.settings-navigation').on('click', function(e){
    var settings_nav = $(this).find("a").attr('href');

    $(this).addClass("settings-navigation-active");
    $(this).siblings().removeClass("settings-navigation-active");
    $(this).find("a").addClass("settings-anchor-active");
    $(this).siblings().children("a").removeClass("settings-anchor-active");

    $('.main-settings-container ' + settings_nav).show().siblings().hide();
    e.preventDefault();
    e.stopPropagation();

  });

  //settings edit slide downs the form

  $('.main-settings-edit').on('click', function(e){
    var settings_form = $(this).attr('href');
    $('.main-settings-container ' + settings_form).slideDown();
    e.preventDefault();
    e.stopPropagation();

  });

  //settings cancel button slides the forms

  $('.settings-edit-cancel').on('click', function(e){ 
    $(this).closest(".main-settings-form").slideUp();
    e.preventDefault();
    e.stopPropagation();

  });
});

//settings password validation 

$(document).ready(function () { //This confirms if the 2 passwords match
//http://stackoverflow.com/questions/39823079/html5-custom-validation-for-passwords/39823092#39823092 
$('#confirm-password').on('keyup', function (e) { 

        var pwd1 = $("#new-password").get(0); //get() gets the dom node, not the value
        var pwd2 = $("#confirm-password").get(0);
        pwd2.setCustomValidity("");

        if (pwd1.value != pwd2.value) { 
            document.getElementById("confirm-password").setCustomValidity("The passwords don't match"); //The document.getElementById("cnfrm-pw") selects the id, not the value
          }

          else {
            document.getElementById("confirm-password").setCustomValidity("");
            //empty string means no validation error
          }
        e.preventDefault();  //would still work if this wasn't present


      });

});