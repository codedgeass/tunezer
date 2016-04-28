module VideosHelper
  def youtube_embed(youtube_url)
    youtube_url =~ /^.*(watch\?)\??v?=?([^\&\?]*).*/
    youtube_id = $2
    %Q(<iframe width="480" height="270" 
      src="https://www.youtube.com/embed/#{youtube_id}" frameborder="0" allowfullscreen></iframe>)
  end
end