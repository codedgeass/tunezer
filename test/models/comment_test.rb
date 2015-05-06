require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'parse_symbols on the input "@admin"' do
    comment = Comment.new(content: '@admin', user_id: users(:johan).id)
    comment.parse_symbols
    assert_equal "<a href=/profiles/#{profiles(:admin).id}>@admin</a> ", comment.content
  end
  
  test 'parse_symbols is notifying referenced users' do
    comment = Comment.new(content: '@admin!!!', user_id: users(:johan).id)
    comment.parse_symbols
    assert_equal 2, users(:admin).profile.notifications.count
  end
  
  test 'parse_symbols on the input "`Video_12`!!!"' do
    concert = concerts(:swift)
    comment = Comment.new(concert_id: concert.id, content: '`Video_12`!!!')
    comment.parse_symbols
    assert_equal "<adata-remote='true'href=/concerts/#{concert.id}/videos/12>Video_12!!!</a>", 
      comment.content.gsub(/\s+/, "")
  end
end