class NotificationsController < ApplicationController
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    @notifications = Profile.find(@notification.profile_id).notifications
    respond_to do |format|
      format.js
    end
  end
end
