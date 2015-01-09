require 'test_helper'

class NotificationsControllerTest < ActionController::TestCase
  def setup
    @notification = notifications(:first)
  end
  
  test 'destroy should successfully respond to an AJAX request' do
    delete :destroy, { profile_id: @notification.profile_id, id: @notification.id, format: :js }
    assert_response :success
  end
  
  test 'destroy should set one instance variable' do
    delete :destroy, { profile_id: @notification.profile_id, id: @notification.id, format: :js }
    assert_not_nil assigns(:notification)
  end
  
  test 'destroy should delete a record' do
    assert_difference('Notification.count', -1) do
      delete :destroy, { profile_id: @notification.profile_id, id: @notification.id, format: :js }
    end
  end
end