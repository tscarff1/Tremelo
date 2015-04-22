// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/effect-bounce
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require bootstrap-sprockets
//= require underscore
//= require gmaps/google
//= require_tree .
//= require jquery_nested_form

// allows the hiding/closing of the flash message when
// clicking on the 'X'
$(document).ready(function() {
    $('button.close').click(function() {
        $(".flash.alert-box").slideUp("fast");
    });
});

// Allows deleting menu items dynamically on forms (such as adding members in the band sign up)
function remove_fields(link){
	$(link).previous("input[type=hidden]").value = "1";
	$(link).up(".fields").hide()
} 