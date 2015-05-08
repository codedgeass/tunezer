// AJAX Pagination Functionality

$(function() {
  $('#comments, #show_videos, #index_rankings, #show_rankings').on('click', '.pagination a',
	function() {
		$.getScript(this.href); // URL of the link that they clicked
		return false;
  });
});

// Search Functionality

/* 
  The search form gets bound to TypeWatch every time it's focused in on. 
  This allows the TypeWatch plugin to be bound to any dynamically generated form. 
  However, there exists some overhead here since the code might unecessarily rebind TypeWatch to a form
  if a user focuses on the same form's input more than once.
*/

$(function() {
  typewatchLoad();
  $('#index_search_container').on('focusin', 'form.typewatch_search', function() {
    typewatchLoad();
  });
});

function typewatchLoad() {
	searchKeyup();
	$('form.typewatch_search').on('submit', function() {
		return false;
	});
}

function searchKeyup() {
	var options = {
	    callback: typewatchSearch,
	    wait: 350,
	    highlight: false,
	    captureLength: 0
	}
	$('form.typewatch_search input').typeWatch(options);
}

function typewatchSearch() {
	$.get($('form.typewatch_search').attr('action'), $('form.typewatch_search input').serialize(), null, 'script');
	//				Destination URL				                   Input from search form passed as query string parameter(s).
}