// Star Voting Functionality

$(function() { // Sets up the stars to match the user's data
	$.renderOldVotes = function() {
		var checkedId1 = $('form.people > input:checked').attr('id');
		var checkedId2 = $('form.music > input:checked').attr('id');
		var checkedId3 = $('form.venue > input:checked').attr('id');
		var checkedId4 = $('form.atmosphere > input:checked').attr('id');
		$('form.people > label[for=' + checkedId1 + ']').prevAll().andSelf().addClass('checked');
		$('form.music > label[for=' + checkedId2 + ']').prevAll().andSelf().addClass('checked');
		$('form.venue > label[for=' + checkedId3 + ']').prevAll().andSelf().addClass('checked');
		$('form.atmosphere > label[for=' + checkedId4 + ']').prevAll().andSelf().addClass('checked');
	};
	$.renderOldVotes();
});

$(document).ready(function() {
	// Makes stars glow on hover.
	$('#voting').on('mouseenter', 'form.people > label, form.music > label, form.venue > label, form.atmosphere > label',
		function() {
			$this = $(this);
			$($this).siblings().andSelf().removeClass('checked');
			$($this).prevAll().andSelf().addClass('glow');
		}
	);
  
	$('#voting').on('mouseout', 'form.people > label, form.music > label, form.venue > label, form.atmosphere > label',
		function() {
			$this = $(this);
			$($this).siblings().andSelf().removeClass('glow');
			$.renderOldVotes();
		}
	);
  
	$('#voting').on('click', 'form.people > label, form.music > label, form.venue > label, form.atmosphere > label',
    function() {
  		$(this).siblings().removeClass('checked');
  		$(this).prevAll().andSelf().addClass('checked');
	  }
  );
  
	$('#voting').on('change', 'form.people', function() {
		$('form.people').submit();
	});
  
	$('#voting').on('change', 'form.music', function() {
		$('form.music').submit();
	});
  
	$('#voting').on('change', 'form.venue', function() {
		$('form.venue').submit();
	});
  
	$('#voting').on('change', 'form.atmosphere', function() {
		$('form.atmosphere').submit();
	});
});