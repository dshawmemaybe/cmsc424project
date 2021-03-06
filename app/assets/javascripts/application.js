// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-select
//= require_tree .
$(document).ready(function() {
  $("a").click(function() {
    link_host = this.href.split("/")[2];
    document_host = document.location.href.split("/")[2];

    if (link_host != document_host) {
      window.open(this.href);
      return false;
    }
  });
});
$(function() {

// Sidebar active state activation
$(".panel-heading").click(function(){
    if ($(this).hasClass("active") && !$(this).hasClass("home")){$(this).removeClass("active")}
      else {
        $(".panel-heading").removeClass("active");
    $(this).addClass("active");
  }
  });

// AJAX request for inserting html documents
$("#htmlinsert").click(function() {
	$.ajax({
    url : "http://localhost:3000/dagrs/new",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#nonhtmlinsert").click(function() {
    $.ajax({
    url : "http://localhost:3000/newnonhtml",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
        $("#content").html(data);
    },
    error: function (jqXHR, textStatus, errorThrown)
    {
        alert(errorThrown);
    }
});
});

$("#dagrhome").click(function() {
	$.ajax({
    url : "http://localhost:3000/mainindex",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#metadataquery").click(function() {
	$.ajax({
    url : "http://localhost:3000/metadataquerystart",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#duplicatequery").click(function() {
	$.ajax({
    url : "http://localhost:3000/duplicatequerystart",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#orphanquery").click(function() {
	$.ajax({
    url : "http://localhost:3000/orphanquerystart",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#reachquery").click(function() {
	$.ajax({
    url : "http://localhost:3000/reachquerystart",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

$("#timequery").click(function() {
	$.ajax({
    url : "http://localhost:3000/timequerystart",
    type: "GET",
    dataType: "HTML",
    success: function(data, textStatus, jqXHR)
    {
    	$("#content").html(data);
	},
    error: function (jqXHR, textStatus, errorThrown)
    {
 		alert(errorThrown);
    }
});
});

});