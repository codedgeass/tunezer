require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  def setup
    u = users(:admin)
    u.confirm!
    sign_in u
    @video = videos(:first_video)
    @new_video = { url: 'https://www.youtube.com/watch?v=B9aBJzzXV3A' }
  end
  
  # Test user authentication for this controller.
  
  test 'new should redirect the client if the user is not signed in' do
    sign_out users(:admin)
    get :new, { concert_id: @video.concert_id }
    assert_response :redirect
  end
  
  # Test the `new` action.
  
  test 'new should redirect an HTML request' do
    get :new, { concert_id: @video.concert_id }
    assert_redirected_to concert_path(@video.concert_id, new_video?: true)
  end
  
  test 'new should successfully respond to an AJAX request' do
    xhr :get, :new, { concert_id: @video.concert_id, format: :js }
    assert_response :success
  end
  
  test 'new should set two instance variables' do
    get :new, { concert_id: @video.concert_id }
    assert_not_nil assigns(:video)
    assert_not_nil assigns(:concert)
  end
  
  # Test the `create` action.
  
  test 'create should successfully respond to an AJAX request' do
    post :create, { concert_id: @video.concert_id, video: @new_video, format: :js }
    assert_response :success
  end
  
  test 'create should redirect an HTML request' do
    post :create, { concert_id: @video.concert_id, video: @new_video }
    assert_redirected_to concert_path(@video.concert_id)
  end
  
  test 'create should set three instance variables when successful' do
    post :create, { concert_id: @video.concert_id, video: @new_video }
    assert_not_nil assigns(:video)
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:videos)
  end
  
  test 'create should add a video to the db' do
    assert_difference('Video.count') do
      post :create, { concert_id: @video.concert_id, video: @new_video }
    end
  end
  
  # Test the `index` action.
  
  test 'index should successfully respond to an AJAX request' do
    xhr :get, :index, { concert_id: @video.concert_id, id: @video.id, format: :js }
    assert_response :success
  end
  
  test 'index should redirect an HTML request' do
    get :index, { concert_id: @video.concert_id, id: @video.id }
    assert_redirected_to concert_path(@video.concert_id)
  end
  
  test 'index should set two instance variables' do
    get :index, { concert_id: @video.concert_id, id: @video.id }
    assert_not_nil assigns(:videos)
    assert_not_nil assigns(:concert)
  end
  
  # Test the `show` action.
  
  test 'show should successfully respond to an AJAX request' do
    xhr :get, :show, { concert_id: @video.concert_id, id: @video.id, format: :js }
    assert_response :success
  end
  
  test 'show should successfully respond to an AJAX request with the reference_video param' do
    xhr :get, :show, { concert_id: @video.concert_id, id: @video.id, reference_video: true, format: :js }
    assert_response :success
  end
  
  test 'show should redirect an HTML request' do
    get :show, { concert_id: @video.concert_id, id: @video.id }
    assert_redirected_to concert_path(@video.concert_id)
  end
  
  test 'show should set one instance variable' do
    get :show, { concert_id: @video.concert_id, id: @video.id }
    assert_not_nil assigns(:video)
  end
  
  # Test the `destroy` action.
  
  test 'destroy should successfully respond to an AJAX request' do
    delete :destroy, { concert_id: @video.concert_id, id: @video.id, video_number: 1, format: :js }
    assert_response :success
  end
  
  test 'destroy should set three instance variables' do
    delete :destroy, { concert_id: @video.concert_id, id: @video.id, video_number: 1, format: :js }
    assert_not_nil assigns(:videos)
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:video)
  end
  
  test 'destroy should remove a video from the db' do
    assert_difference('Video.count', -1) do
      delete :destroy, { concert_id: @video.concert_id, id: @video.id, video_number: 1, format: :js }
    end
  end
end