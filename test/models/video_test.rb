require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  def setup
    @video = Video.new
  end
  
  test 'should not save a video without a url' do
    assert_not @video.save
  end
  
  test 'should not save a video if its url isnt from youtube' do
    @video.url = 'vimeo.com/113645916'
    assert_not @video.save
  end
  
  test 'should not save a video if a video with the same URL already exists' do
    @video.url = 'https://www.youtube.com/watch?v=N2rj3os3IYg'
    assert_not @video.save
  end
  
  test 'should truncate the URL so it begins with the domain name' do
    @video.url = 'https://www.youtube.com/watch?v=ZtLFmOVyMb8'
    @video.save!
    assert_equal 'youtube.com/watch?v=ZtLFmOVyMb8', @video.url
  end
end