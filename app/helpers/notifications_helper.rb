module NotificationsHelper
  def get_production_id(notification)
    comment = Comment.find(notification.comment_id)
    comment.production_id
  end
end