require 'test_helper'

class ProductionsControllerTest < ActionController::TestCase
  def setup
    u = users(:admin)
    u.confirm!
    sign_in u
    @production = productions(:ultra)
    @new_production = { name: 'Foo', genre: 'Foo', category: 'Foo' }
  end
  
  # Test user authentication for this controller.
  
  test 'new should not authorize the client if the user is not signed in' do
    sign_out users(:admin)
    get :new, { id: @production.id }
    assert_response :redirect
  end
  
  # Test the `new` action.
  
  test 'new should successfully respond to an HTML request' do
    get :new
    assert_response :success
  end
  
  test 'new should successfully respond to an AJAX request' do
    xhr :get, :new, { new_search: 'Foo', format: :js }
    assert_response :success
  end
  
  test 'new should set the instance variable empty_search when the search is blank' do
    get :new, { new_search: '' }
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:empty_search)
  end
  
  test 'new should set the instance variable productions when the search is not blank' do
    get :new, { new_search: 'foo' }
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:productions)
  end
  
  # Test the `create` action.
  
  test 'create should redirect an HTML request when successful' do
    post :create, { production: @new_production }
    assert_response :redirect
  end
  
  test 'create should successfully respond to a failed HTML request' do
    @new_production[:category] = nil
    post :create, { production: @new_production }
    assert_response :success
  end
  
  test 'create should set one instance variable' do
    post :create, { production: @new_production }
    assert_not_nil assigns(:production)
  end
  
  test 'create should add a production to the db' do
    assert_difference('Production.count') do
      post :create, { production: @new_production }
    end
  end
  
  # Test the `index` action.
  
  test 'index should successfully respond to an AJAX request' do
    xhr :get, :index, { format: :js }
    assert_response :success
  end
  
  test 'index should successfully respond to an HTML request' do
    get :index
    assert_response :success
  end
  
  test 'index should set five instance variables' do
    get :index, { index_search: 'foo' }
    assert_not_nil assigns(:klass)
    assert_not_nil assigns(:category)
    assert_not_nil assigns(:genre)
    assert_not_nil assigns(:productions_or_concerts)
    assert_not_nil assigns(:index_search)
  end
  
  test 'index should default to selecting all productions' do
    get :index
    assert_equal 4, assigns(:productions_or_concerts).size
  end
  
  test 'index should select records only of the given genre, category, and search criteria' do
    get :index, { klass: 'Concert', category: 'Artist', genre: 'Country', index_search: '2014' }
    assigns(:productions_or_concerts).each do |concert_or_production|
      assert_equal 'Country', concert_or_production.genre
      assert_equal 'Artist', concert_or_production.category
      assert concert_or_production.name.downcase.include?('2014')
    end
  end
  
  test 'index should instantiate the given class' do
    get :index, { category: 'Artist', klass: 'Concert', index_search: '2014' }
    assert_equal 'Concert', assigns(:productions_or_concerts).class.to_s.deconstantize
  end
  
  # Test the `show` action.
  
  test 'show should successfully respond to an AJAX request' do
    xhr :get, :show, { id: @production.id, format: :js }
    assert_response :success
  end
  
  test 'show should successfully respond to an HTML request' do
    get :show, { id: @production.id }
    assert_response :success
  end
  
  test 'show should set five instance variables without additional parameters' do
    get :show, { id: @production.id }
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:concerts)
    assert_not_nil assigns(:videos)
    assert_not_nil assigns(:comments)
    assert_not_nil assigns(:comment)
  end
  
  test 'show should set the instance variable linked_comment when a linked comment is present' do
    get :show, { id: @production.id, linked_comment: comments(:first).id }
    assert_not_nil assigns(:linked_comment)
  end
  
  test 'show should set the instance variables concert and rating when a concert id is present' do
    get :show, { id: @production.id, concert_id: concerts(:ultra_2014).id }
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:rating)
  end
  
  # Test the `destroy` action.
  
  test 'destroy should successfully respond to an AJAX request' do
    xhr :delete, :destroy, { id: @production.id, format: :js }
    assert_response :success
  end
  
  test 'destroy should set three instance variables when responding to an AJAX request' do
    xhr :delete, :destroy, { id: @production.id, format: :js }
    assert_not_nil assigns(:productions_or_concerts)
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:klass)
  end
  
  test 'destroy should remove a production from the db' do
    assert_difference('Production.count', -1) do
      xhr :delete, :destroy, { id: @production.id, format: :js }
    end
  end
end