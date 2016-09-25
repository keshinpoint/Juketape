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
//= require_tree .

<<<<<<< HEAD


$(document).ready( function() {

    $(window).scroll( function() {
        if ($(window).scrollTop() > $('#dashfolio-main-row').offset().top)
            $('.dashfolio-content-dashbar').addClass('sticky');         

        else
            $('.dashfolio-content-dashbar').removeClass('sticky');
    } );

} );


$(document).ready(function() {
  $('#nav-notif-counter').css({ opacity: 0 }).animate({ top: '-1px', opacity: 1 }, 500);

});



$(document).on('turbolinks:load', function() {
  $(function() {
    $('.best_in_place').best_in_place();
    $('.datepicker_input').datepicker({
      dateFormat: "dd/mm/yy"
    });
    $('[data-toggle="tooltip"]').tooltip();
    $(".inbox-main-message-body").scrollTop($('.inbox-main-message-body')[0].scrollHeight);
  });

  $('form.dashfolio-timeline-form').on('ajax:error', function(jqXHR, error) {
    var $errorObj = $('form.dashfolio-timeline-form .errors');
    $errorObj.html(error.responseText);
  });

  $('#event_end_date_checkbox').on('change', function() {
    $('.timeline-form-end-date').prop('disabled', function(i, v) { return !v; });
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
    });

  }); //end of $('#filterContentModal')

  $('#add_tag_form')
    .on('ajax:success', function(data, jqXHR) {
      $('#add-tag-input').val('');
      $('#tag-container .tags-list').append(jqXHR.content);
      console.log(jqXHR.content);
      if(jqXHR.tags_count >= 5) {
        $('#add-tag-input-group').hide();
      }
      
    }).on('ajax:error', function(jqXHR, error) {
      console.log('Its Error')
    });
});

// Below is the javascript for static pages
$(document).ready(function() {
  $('#add-tag-form-button').on('click', function(){
    $('#add-tag-input-group').show();
    $(this).hide();
  });

  $('#cancel-tag-form-button').on('click', function(){
    $('#add-tag-input-group').hide();
    $('#add-tag-form-button').show();
  });


	$('.dashfolio-midbar-about a').on('click', function(e){
		var currentAttrValue1 = $(this).attr('href');

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

		$('.dashfolio-music').show();
    $('#tracks-dashfolio').show();
		$('.main-content ' + currentAttrValue2).fadeIn(400);
		$('.dashfolio-about').hide();
		$('.dashfolio-video').hide();
		$('.dashfolio-pictures').hide();
		 e.preventDefault();
		 e.stopPropagation();		
		});	

		$('.dashfolio-midbar-videos a').on('click', function(e){
			var currentAttrValue3 = $(this).attr('href');

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

			$('.dashfolio-pictures').show();
			$('.main-content ' + currentAttrValue4).fadeIn(400);
			$('.dashfolio-music').hide();
			$('.dashfolio-about').hide();
			$('.dashfolio-video').hide();
			e.preventDefault();	
			e.stopPropagation();
		});

});



$(document).ready(function(){
$('.music-header-container a').on('click', function(e){
var attribute_tabcontent_music = $(this).attr('href');
$(this).addClass("music-header-container-active");
 $(this).siblings().removeClass("music-header-container-active");


$('.music-content ' + attribute_tabcontent_music).fadeIn(400).siblings().hide();
$('.dashfolio-about').hide();
$('.dashfolio-video').hide();
$('.dashfolio-pictures').hide();
e.preventDefault(); 
e.stopPropagation();		 

});

  $('.about-header-container a').on('click', function(e){

    var attribute_tabcontent_about = $(this).attr('href');
    $('.about-content ' + attribute_tabcontent_about).fadeIn(400).siblings().hide();

    $(this).addClass("about-header-container-active");
    $(this).siblings().removeClass("about-header-container-active");
    $('.dashfolio-music').hide();
    $('.dashfolio-video').hide();
    $('.dashfolio-pictures').hide();
        e.preventDefault();
  });

});

//conenction request invite 

$(document).ready(function() {
	
  $('input[type=radio]').change(function() {
    if ($('#connection-invite-other-radio').is(':checked')) {
      $('#connection-invite-other').show();
      $('#connection-invite-other input').prop('disabled', false);
    } 
    else {
      $('#connection-invite-other').hide();
      $('#connection-invite-other input').prop('disabled', true);
    }
  });
});
