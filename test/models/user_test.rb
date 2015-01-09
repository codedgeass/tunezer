require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save a user without a username' do
    u = users(:no_username)
    assert_not u.save
  end
  
  test 'should not save a user if its username has already been taken' do
    u = User.new(username: 'admin', email: 'admin2@tuneaddicts.com', password: 'password')
    assert_not u.save
  end
end
