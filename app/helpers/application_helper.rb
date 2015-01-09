module ApplicationHelper
  def render_stars(aggregate_score)
    StarsRenderer.new(aggregate_score, self).assemble_div_for_stars
  end
end
