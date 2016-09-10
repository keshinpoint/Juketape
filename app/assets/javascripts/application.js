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

$(document).ready(function() {
	$('.dashfolio-midbar-about a').on('click', function(e){
		var currentAttrValue1 = $(this).attr('href');

		$('.dashfolio-about').show()
		$('.main-content ' + currentAttrValue1).fadeIn(400);		
		$('.dashfolio-music').hide();
		$('.dashfolio-videos').hide();
		e.preventDefault();      

	});

		$('.dashfolio-midbar-music a').on('click', function(e){
		var currentAttrValue2 = $(this).attr('href');

		$('.dashfolio-music').show()
		$('.main-content ' + currentAttrValue2).fadeIn(400);
		$('.dashfolio-about').hide();
		$('.dashfolio-videos').hide();
		 e.preventDefault();		
});

		$('.dashfolio-midbar-videos a').on('click', function(e){
			var currentAttrValue3 = $(this).attr('href');

			$('.dashfolio-video').show();
			$('.main-content ' + currentAttrValue3).fadeIn(400);
			$('.dashfolio-music').hide();
			$('.dashfolio-about').hide();
			e.preventDefault();
		});

});

$(document).ready(function(){

$('.about-header-container a').on('click', function(e){
var attribute_tabcontent_about = $(this).attr('href');

$('.about-content ' + attribute_tabcontent_about).fadeIn(400).siblings().hide();
$('.dashfolio-music').hide();
$('.dashfolio-video').hide();

e.preventDefault();      

});

$('.music-header-container a').on('click', function(e){
var attribute_tabcontent_music = $(this).attr('href');

$('.music-content ' + attribute_tabcontent_music).fadeIn(400).siblings().hide();
$('.dashfolio-about').hide();
$('.dashfolio-video').hide();
e.preventDefault();  

});

});


