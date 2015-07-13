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


// Changes the colors in the genre selections.

$(function() {
  $('.genre_box a').on('click', function() {
    $('.genre_box a').css('color','');
    $(this).css('color','#09f');
  });
});