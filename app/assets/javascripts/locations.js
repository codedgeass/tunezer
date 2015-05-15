// Autocomplete functionality for location searching in '/concerts'.

$(function() {
  $('.location_search').autocomplete({
    autoFocus: true,
    focus: function( event, ui ) {
      return false;
    },
    source: '/locations',
    select: function( event, ui ) { 
                window.location.href = ui.item.value;
                return false;
            }
  });
});

// Disables the submission on location searching in '/concerts'.

$(function() {
  $('.location_search_form').on('submit', function(){
    return false;
  });
});