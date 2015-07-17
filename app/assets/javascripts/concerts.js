// AJAX Pagination Functionality

$(function() {
  $('.comments, #show_videos, .rankings').on('click', '.pagination a',
	function() {
		$.getScript(this.href); // URL of the link that they clicked
		return false;
  });
});


// Autocomplete functionality for event searching in '/concerts'.

$(function() {
  $('.event_search').autocomplete({
    autoFocus: true,
    focus: function( event, ui ) {
      return false;
    },
    source: '/concerts',
    select: function( event, ui ) { 
                window.location.href = ui.item.value;
                return false;
            }
  });
});


// Disables the submission on event searching in '/concerts'.

$(function() {
  $('.event_search_form').on('submit', function() {
    return false;
  });
});


// Changes the colors and the submission content of the genre filter selections.

$(function() {
  $('.genre_link').on('click', function() {
    if ( $(this).hasClass('selected') ) {
      $(this).removeClass('selected');
      $.getScript('/concerts?genre=All');
      return false;
    }
    else {
      $('.genre_link').removeClass('selected');
      $(this).addClass('selected');
    }
  });
});