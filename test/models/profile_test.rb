require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test 'should not save if the real_name and hometown attributes contain numbers' do
    assert_not Profile.new(real_name: '123').save
    assert_not Profile.new(hometown: '123').save
  end
  
  test 'should not save if the age attribute contains letters' do
    assert_not Profile.new(age: 'foo').save
  end
  
  test 'should not save if all the attributes are blank' do
    profiles(:admin).user_id = nil
    assert_not profiles(:admin).save
  end
end