// AJAX Pagination Functionality

$(function() {
  $('.rankings_list').on('click', '.pagination a',
	function() {
		$.getScript(this.href + '&sort=' + $('#sort_rankings').val() + '&size=' + $('#rankings_size').val() );
		return false;
  });
});

$(function() {
  $('#show_videos_index').on('click', '.pagination a',
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

// Filtering options for the rankings list

$(function () {
  $('.rankings_list').on('change', '#sort_rankings', function() {
    $.getScript('/concerts?sort=' + this.value + '&size=' + $('#rankings_size').val() )
  })
})

$(function () {
  $('.rankings_list').on('change', '#rankings_size', function() {
    $.getScript('/concerts?size=' + this.value + '&sort=' + $('#sort_rankings').val() )
  })
})