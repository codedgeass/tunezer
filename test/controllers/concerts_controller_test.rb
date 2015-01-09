require 'test_helper'

class ConcertsControllerTest < ActionController::TestCase
  def setup
    u = users(:admin)
    u.confirm!
    sign_in u
    @concert = concerts(:swift_2014)
    @new_concert = { name: 'Foo', genre: 'Foo', production_id: @concert.production_id }
  end
  
  # Test user authentication for this controller.
  
  test 'new should redirect the client if the user is not signed in' do
    sign_out users(:admin)
    get :new, { production_id: @concert.production_id, id: @concert.id }
    assert_response :redirect
  end
  
  # Test the `new` action.
  
  test 'new should redirect an HTML request' do
    get :new, { production_id: @concert.production_id }
    assert_redirected_to production_path(@concert.production_id, new_concert?: true)
  end
  
  test 'new should successfully respond to an AJAX request' do
    xhr :get, :new, { production_id: @concert.production_id, format: :js }
    assert_response :success
  end
  
  test 'new should set two instance variables' do
    get :new, { production_id: @concert.production_id }
    assert_not_nil assigns(:concert)
  end
  
  # Test the `create` action.
  
  test 'create should successfully respond to an AJAX request' do
    post :create, { production_id: @concert.production_id, concert: @new_concert, format: :js }
    assert_response :success
  end
  
  test 'create should redirect an HTML request' do
    post :create, { production_id: @concert.production_id, concert: @new_concert }
    assert_redirected_to production_path(@concert.production_id)
  end
  
  test 'create should set three instance variables when successful' do
    post :create, { production_id: @concert.production_id, concert: @new_concert }
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:concerts)
  end
  
  test 'create should add a concert to the db' do
    assert_difference('Concert.count') do
      post :create, { production_id: @concert.production_id, concert: @new_concert }
    end
  end
  
  # Test the `index` action.
  
  test 'index should successfully respond to an AJAX request' do
    xhr :get, :index, { production_id: @concert.production_id, format: :js }
    assert_response :success
  end
  
  test 'index should redirect an HTML request' do
    get :index, { production_id: @concert.production_id, concerts_page: 1 }
    assert_redirected_to production_path(@concert.production_id, concerts_page: 1)
  end
  
  test 'index should set two instance variables when a user is signed in' do
    get :index, { production_id: @concert.production_id }
    assert_not_nil assigns(:concerts)
    assert_not_nil assigns(:production)
  end
  
  # Test the `show` action.
  
  test 'show should successfully respond to an AJAX request' do
    xhr :get, :show, { production_id: @concert.production_id, id: @concert.id, concerts_page: 1, format: :js }
    assert_response :success
  end
  
  test 'show should redirect an HTML request' do
    get :show, { production_id: @concert.production_id, id: @concert.id }
    assert_redirected_to production_path(@concert.production_id, concert_id: @concert.id)
  end
  
  test 'show should set three instance variables when a user is signed in' do
    get :show, { production_id: @concert.production_id, id: @concert.id }
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:rating)
  end
  
  # Test the `destroy` action.
  
  test 'destroy should successfully respond to an AJAX request' do
    delete :destroy, { production_id: @concert.production_id, id: @concert.id, format: :js }
    assert_response :success
  end
  
  test 'destroy should set three instance variables' do
    delete :destroy, { production_id: @concert.production_id, id: @concert.id, format: :js }
    assert_not_nil assigns(:concerts)
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:concert)
  end
  
  test 'destroy should remove a concert from the db' do
    assert_difference('Concert.count', -1) do
      delete :destroy, { production_id: @concert.production_id, id: @concert.id, format: :js }
    end
  end
end