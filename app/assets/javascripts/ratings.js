// Star Voting Functionality

$(function() { // Sets up the stars to match the user's data
	renderOldVotes = function() {
		var checkedId1 = $('form.people_score > input:checked').attr('id');
		var checkedId2 = $('form.music_score > input:checked').attr('id');
		var checkedId3 = $('form.venue_score > input:checked').attr('id');
		var checkedId4 = $('form.atmosphere_score > input:checked').attr('id');
		$('form.people_score > label[for=' + checkedId1 + ']').prevAll().andSelf().addClass('checked');
		$('form.music_score > label[for=' + checkedId2 + ']').prevAll().andSelf().addClass('checked');
		$('form.venue_score > label[for=' + checkedId3 + ']').prevAll().andSelf().addClass('checked');
		$('form.atmosphere_score > label[for=' + checkedId4 + ']').prevAll().andSelf().addClass('checked');
	};
	renderOldVotes();
});

$(document).ready(function() {
	// Makes stars glow on hover.
	$('#voting').on('mouseenter', 'form.people_score > label, form.music_score > label, form.venue_score > label, form.atmosphere_score > label',
		function() {
			$(this).siblings().andSelf().removeClass('checked');
			$(this).prevAll().andSelf().addClass('glow');
		}
	);
  
	$('#voting').on('mouseout', 'form.people_score > label, form.music_score > label, form.venue_score > label, form.atmosphere_score > label',
		function() {
			$(this).siblings().andSelf().removeClass('glow');
			renderOldVotes();
		}
	);
  
	$('#voting').on('click', 'form.people_score > label, form.music_score > label, form.venue_score > label, form.atmosphere_score > label',
    function() {
      $(this).siblings().andSelf().removeClass('glow');
  		$(this).prevAll().andSelf().addClass('checked');
	  }
  );
  
	$('#voting').on('change', 'form.people_score', function() {
		$('form.people_score').submit();
	});
  
	$('#voting').on('change', 'form.music_score', function() {
		$('form.music_score').submit();
	});
  
	$('#voting').on('change', 'form.venue_score', function() {
		$('form.venue_score').submit();
	});
  
	$('#voting').on('change', 'form.atmosphere_score', function() {
		$('form.atmosphere_score').submit();
	});
});