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
//= require_tree .

$(document).ready(function(){

	$('.midbar-icon a').on('click', function(e){
		var currentAttrValue = $(this).attr('href');

		$('.main-content ' + currentAttrValue).fadeIn(400).siblings().hide();
		
			   e.preventDefault();
			   e.stopPropagation();
	});

	$('.tablink').on('click', function(e) {
        var currentAttrValue = $(this).attr('href');
 
        // Show/Hide Tabs
        $('.dashfolio-about ' + currentAttrValue).fadeIn(400).siblings().hide(); //choose the dashfolio-about parent div, and search for children divs with id = cuurent value attr
 
        // Change/remove current tab to active
        $(this).addClass('active').siblings().removeClass('active');
 
        e.preventDefault();
    });

});


