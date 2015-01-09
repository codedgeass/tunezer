require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  def setup
    u = users(:admin)
    u.confirm!
    sign_in u
    @profile = profiles(:admin)
  end
  
  # Test user authentication for this controller.
  
  test 'show should redirect the client if the user is not signed in' do
    sign_out users(:admin)
    get :show, { id: @profile }
    assert_response :redirect
  end
  
  # Test the `show` action.
  
  test 'show should successfully respond to an HTML request' do
    get :show, { id: @profile }
    assert_response :success
  end
  
  test 'show should set two instance variables' do
    get :show, { id: @profile }
    assert_not_nil assigns(:profile)
    assert_not_nil assigns(:notifications)
  end
  
  # Test the `edit` action.
  
  test 'edit should successfully respond to an HTML request' do
    get :edit, { id: @profile }
    assert_response :success
  end
  
  test 'edit should set one instance variable' do
    get :edit, { id: @profile }
    assert_not_nil assigns(:profile)
  end
  
  # Test the `update` action.
  
  test 'a successful update should redirect the request' do
    new_profile = 
      { real_name: 'Mike', age: 28, hometown: 'Chicago', favorite_artists: 'Deadmau5', favorite_songs: 'Find You' }
    patch :update, { id: @profile, profile: new_profile }
    assert_redirected_to profile_path(assigns(:profile))
  end
  
  test 'a failed update should successfully respond to the request' do
    new_profile = { real_name: '' }
    patch :update, { id: @profile, profile: new_profile }
    assert_response :success
  end
end