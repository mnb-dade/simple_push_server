$(function() {
	
  var es = new EventSource('/stream');

  es.onmessage = function(event) { 
    // var msg = $.parseJSON(event.data);
		$('#output').prepend('<p>' + event.data + '</p>');
  }
  
});