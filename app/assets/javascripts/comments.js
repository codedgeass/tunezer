$(function() {
  $('.comments').on('click', '.comment_entries .comment_entry .comment_footer .delete_comment', 
    function() {
      $(this).addClass('marked_for_deletion');
    }
  );
});