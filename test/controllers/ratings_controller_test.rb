require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  def setup
    u = users(:admin)
    u.confirm!
    sign_in u
    @production = productions(:swift)
    @rating = ratings(:swift_2012_7)
  end
  
  # Test user authentication for this controller.
  
  test 'create should redirect the client if the user is not signed in' do
    sign_out users(:admin)
    get :create, { concert_id: @rating.concert_id }
    assert_response :redirect
  end
  
  # Test the `create` action.
  
  test 'create should successfully respond to an AJAX request' do
    post :create, { concert_id: @rating.concert_id, rating_people: 7, concerts_page: 1, format: :js }
    assert_response :success
  end
  
  test 'create should redirect an HTML request' do
    post :create, { concert_id: @rating.concert_id, rating_people: 7, concerts_page: 1 }
    assert_redirected_to production_path(id: @production.id, concert_id: @rating.concert_id)
  end
  
  test 'create should set one instance variable when successful' do
    post :create, { concert_id: @rating.concert_id, rating_people: 7, concerts_page: 1 }
    assert_not_nil assigns(:rating)
  end
  
  test 'create should add a rating to the db' do
    assert_difference('Rating.count') do
      post :create, { concert_id: @rating.concert_id, rating_people: 7, concerts_page: 1 }
    end
  end
  
  # Test the `update` action.
  
  test 'update should raise an argument error if the rating remains unchanged' do
    assert_raises ArgumentError do 
       patch :update, { id: @rating.id, concert_id: @rating.concert_id, rating_atmosphere: 7, format: :js }
    end
  end
  
  test 'update should successfully respond to an AJAX request' do
    patch :update, { id: @rating.id, concert_id: @rating.concert_id, rating_atmosphere: 6, format: :js }
    assert_response :success
  end
  
  test 'update should redirect an HTML request' do
    patch :update, { id: @rating.id, concert_id: @rating.concert_id, rating_atmosphere: 6 }
    assert_redirected_to production_path(id: @production.id, concert_id: @rating.concert_id)
  end
  
  test 'update should set four instance variables when successful' do
    patch :update, { id: @rating.id, concert_id: @rating.concert_id, rating_atmosphere: 6 }
    assert_not_nil assigns(:rating)
    assert_not_nil assigns(:production)
    assert_not_nil assigns(:concert)
    assert_not_nil assigns(:concerts)
  end
  
  test 'updating a newly completed rating should incporate the rating into a concert and production' do
    incomplete_rating = ratings(:edc_2014_incomplete)
    patch :update, { id: incomplete_rating.id, concert_id: incomplete_rating.concert_id, rating_atmosphere: 3 }
    assert_equal 2, concerts(:edc_2014).number_of_votes
    assert_equal 4, productions(:edc).number_of_votes
  end
end