class StarsRenderer 
  def initialize(aggregate_score, template)
    @aggregate_score = aggregate_score
    @template = template
  end
  
  def assemble_div_for_stars
    @template.content_tag(:div, star_images, class: 'stars')
  end
  
  def star_images
    (0..9).map do |position|
      star_image(@aggregate_score - position)
    end.join.html_safe
  end
  
  def star_image(value)
    @template.image_tag("#{star_type(value)}_star.gif", size: '30x30')
  end
  
  def star_type(value)
    if value < 0.25
      'empty'
    elsif value < 0.75
      'half'
    else # value >= 0.75
      'full'
    end
  end
end