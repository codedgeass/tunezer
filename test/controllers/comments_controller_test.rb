require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @comment = comments(:first)
    @new_comment = { username: 'Foo', content: 'Foo', concert_id: concerts(:swift).id, user_id: users(:johan).id }
  end
  
  # Test the `create` action.
  
  test 'create should successfully respond to an AJAX request' do
    post :create, { concert_id: @comment.concert_id, comment: @new_comment, format: :js }
    assert_response :success
  end
  
  test 'create should redirect an HTML request' do
    post :create, { concert_id: @comment.concert_id, comment: @new_comment }
    assert_redirected_to concert_path(@comment.concert_id)
  end
  
  test 'create should set three instance variables when successful' do
    post :create, { concert_id: @comment.concert_id, comment: @new_comment }
    assert_not_nil assigns(:comment)
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:comments)
  end
  
  test 'create should add a comment to the db' do
    assert_difference('Comment.count') do
      post :create, { concert_id: @comment.concert_id, comment: @new_comment }
    end
  end
  
  # Test the `index` action.
  
  test 'index should successfully respond to an AJAX request' do
    xhr :get, :index, { concert_id: @comment.concert_id, format: :js }
    assert_response :success
  end
  
  test 'index should redirect an HTML request' do
    get :index, { concert_id: @comment.concert_id, comments_page: 1 }
    assert_redirected_to concert_path(@comment.concert_id, comments_page: 1)
  end
  
  test 'index should set two instance variables when a user is signed in' do
    get :index, { concert_id: @comment.concert_id }
    assert_not_nil assigns(:comments)
    assert_not_nil assigns(:concert)
  end
  
  # Test the `destroy` action.
  
  test 'destroy should successfully respond to an AJAX request' do
    delete :destroy, { concert_id: @comment.concert_id, id: @comment.id, format: :js }
    assert_response :success
  end
  
  test 'destroy should set three instance variables' do
    delete :destroy, { concert_id: @comment.concert_id, id: @comment.id, format: :js }
    assert_not_nil assigns(:comment)
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:comments)
  end

  test 'destroy should remove a comment from the db' do
    assert_difference('Comment.count', -1) do
      delete :destroy, { concert_id: @comment.concert_id, id: @comment.id, format: :js }
    end
  end
end