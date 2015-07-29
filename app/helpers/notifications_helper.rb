module NotificationsHelper
  def get_concert_id(notification)
    comment = Comment.find(notification.comment_id)
    comment.commentable_id
  end
end