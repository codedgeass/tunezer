class NotificationsController < ApplicationController
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    @notifications = Profile.find(@notification.profile_id).notifications
    respond_to do |format|
      format.html { redirect_to profile_path(@notification.profile_id), 
        message: "Successfully deleted the notification by #{@notification.referrer_username}." }
      format.js
    end
  end
end
