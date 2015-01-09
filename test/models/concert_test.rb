require 'test_helper'

class ConcertTest < ActiveSupport::TestCase
  def setup
    @concerts_size_two = [
      Concert.new(aggregate_score: 5, name: 'Foo1', genre: 'Foo1', category: 'Foo1', rank: 1),
      Concert.new(aggregate_score: 3, name: 'Foo2', genre: 'Foo2', category: 'Foo2', rank: 2)
    ]
    @concerts_size_three = [
      Concert.new(aggregate_score: 7, name: 'Foo1', genre: 'Foo1', category: 'Foo1', rank: 1),
      Concert.new(aggregate_score: 5, name: 'Foo2', genre: 'Foo2', category: 'Foo2', rank: 2),
      Concert.new(aggregate_score: 3, name: 'Foo3', genre: 'Foo3', category: 'Foo3', rank: 3)
    ]
  end
  
  test 'should not save a concert without a name' do
    concert = Concert.new
    assert_not concert.save
  end
  
  test 'should not save a concert if its name is not unique to its production' do
    production = productions(:ultra)
    concert = production.concerts.build(name: '2014')
    assert_not concert.save
  end
  
  test 'average_in_category' do
    concert = concerts(:swift_2012)
    concert.average_in_category(5, 6, :people)
    assert_equal 5.5, concert.people
  end
  
  # These tests test `before_destroy` callbacks.
  
  test 'remove_concert_from_concert_rankings' do
    concert = concerts(:ultra_2013)
    concert.send(:remove_concert_from_concert_rankings)
    assert_equal 2, concerts(:ultra_2012).rank
  end
  
  test 'remove_concert_from_concert_rankings with three concerts in a tie' do
    concert = concerts(:ties_2014)
    concert.send(:remove_concert_from_concert_rankings)
    assert_equal 1, concerts(:ties_2013).rank
    assert_equal 1, concerts(:ties_2012).rank
  end
  
  test 'remove_concert_from_production_score' do
    concert = concerts(:edc_2014)
    concert.send(:remove_concert_from_production_score)
    assert_equal 3, productions(:edc).aggregate_score
    assert_equal 2, productions(:ultra).rank
  end
  
  test 'remove_concert_from_production_score remove all concerts' do
    productions(:swift).concerts.destroy_all
    assert_nil productions(:swift, true).rank
  end
  
  # The remaining tests all test the method `update_rankings`.
  
  test 'update_rankings when size is one' do
    concerts = [Concert.new(aggregate_score: 5, name: 'Foo', genre: 'Foo', category: 'Foo', rank: 1)]
    updated_concert = concerts[0]
    updated_concert.aggregate_score = 7
    updated_concert.update_rankings(concerts, 'increased')
    assert_equal 1, updated_concert.rank
  end
  
  # Two concerts involved in the next five tests.
  
  test 'update_rankings when size is two and the updated concert surpasses a concert' do
    updated_concert = @concerts_size_two[1]
    updated_concert.aggregate_score = 7
    updated_concert.update_rankings(@concerts_size_two, 'increased')
    assert_equal 1, updated_concert.rank
    assert_equal 2, @concerts_size_two[0].rank
  end

  test 'update_rankings when size is two and the updated concert increases to equate a concert' do
    updated_concert = @concerts_size_two[1]
    updated_concert.aggregate_score = 5
    updated_concert.update_rankings(@concerts_size_two, 'increased')
    assert_equal 1, updated_concert.rank
    assert_equal 1, @concerts_size_two[0].rank
  end
  
  test 'update_rankings when size is two and the updated concert falls below a concert' do
    updated_concert = @concerts_size_two[0]
    updated_concert.aggregate_score = 2
    updated_concert.update_rankings(@concerts_size_two, 'decreased')
    assert_equal 1, @concerts_size_two[1].rank
    assert_equal 2, updated_concert.rank
  end
  
  test 'update_rankings when size is two and the updated concert surpasses its equal' do
    @concerts_size_two[1].rank = 1
    updated_concert = @concerts_size_two[0]
    updated_concert.aggregate_score = 7
    updated_concert.update_rankings(@concerts_size_two, 'increased')
    assert_equal 1, updated_concert.rank
    assert_equal 2, @concerts_size_two[1].rank
  end
  test 'update_rankings when size is two and the updated concert falls below its equal' do
    @concerts_size_two[1].rank = 1
    updated_concert = @concerts_size_two[1]
    updated_concert.aggregate_score = 2
    updated_concert.update_rankings(@concerts_size_two, 'decreased')
    assert_equal 1, @concerts_size_two[0].rank
    assert_equal 2, updated_concert.rank
  end
  
  # Three concerts involved in the next eight tests.
  
  test 'update_rankings when size is three and the updated concert surpasses two concerts' do
    updated_concert = @concerts_size_three[2]
    updated_concert.aggregate_score = 9
    updated_concert.update_rankings(@concerts_size_three, 'increased')
    assert_equal 1, updated_concert.rank
    assert_equal 2, @concerts_size_three[0].rank
    assert_equal 3, @concerts_size_three[1].rank
  end
  
  test 'update_rankings when size is three and the updated concert falls below two concerts' do
    updated_concert = @concerts_size_three[0]
    updated_concert.aggregate_score = 2
    updated_concert.update_rankings(@concerts_size_three, 'decreased')
    assert_equal 1, @concerts_size_three[1].rank
    assert_equal 2, @concerts_size_three[2].rank
    assert_equal 3, updated_concert.rank
  end
  
  test 'update_rankings when size is three and the updated concert falls below a concert and equates another' do
    updated_concert = @concerts_size_three[0]
    updated_concert.aggregate_score = 3
    updated_concert.update_rankings(@concerts_size_three, 'decreased')
    assert_equal 1, @concerts_size_three[1].rank
    assert_equal 2, @concerts_size_three[2].rank
    assert_equal 2, updated_concert.rank
  end
  
  test 'update_rankings when size is three and the updated concert surpasses its equal' do
    @concerts_size_three[1].rank = 1
    updated_concert = @concerts_size_three[1]
    updated_concert.aggregate_score = 9
    updated_concert.update_rankings(@concerts_size_three, 'increased')
    assert_equal 1, updated_concert.rank
    assert_equal 2, @concerts_size_three[0].rank
    assert_equal 3, @concerts_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated concert falls to last from being tied in first' do
    @concerts_size_three[1].rank = 1
    updated_concert = @concerts_size_three[0]
    updated_concert.aggregate_score = 2
    updated_concert.update_rankings(@concerts_size_three, 'decreased')
    assert_equal 1, @concerts_size_three[1].rank
    assert_equal 2, @concerts_size_three[2].rank
    assert_equal 3, updated_concert.rank
  end
  
  test 'update_rankings when size is three and the updated concert rises to second from being tied in last' do
    @concerts_size_three[1].rank = 2
    updated_concert = @concerts_size_three[1]
    updated_concert.aggregate_score = 6
    updated_concert.update_rankings(@concerts_size_three, 'increased')
    assert_equal 1, @concerts_size_three[0].rank
    assert_equal 2, updated_concert.rank
    assert_equal 3, @concerts_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated concert falls to second from being tied in first' do
    @concerts_size_three[1].rank = 1
    updated_concert = @concerts_size_three[1]
    updated_concert.aggregate_score = 6
    updated_concert.update_rankings(@concerts_size_three, 'decreased')
    assert_equal 1, @concerts_size_three[0].rank
    assert_equal 2, updated_concert.rank
    assert_equal 3, @concerts_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated concert falls to last from being in a three way tie' do
    @concerts_size_three[1].rank = 1
    @concerts_size_three[2].rank = 1
    updated_concert = @concerts_size_three[2]
    updated_concert.aggregate_score = 4
    updated_concert.update_rankings(@concerts_size_three, 'decreased')
    assert_equal 1, @concerts_size_three[0].rank
    assert_equal 1, @concerts_size_three[1].rank
    assert_equal 3, updated_concert.rank
  end
  
  test 'update_rankings when size is three and no rank change is needed' do
    updated_concert = @concerts_size_three[2]
    updated_concert.aggregate_score = 4
    updated_concert.update_rankings(@concerts_size_three, 'increased')
    assert_equal 1, @concerts_size_three[0].rank
    assert_equal 2, @concerts_size_three[1].rank
    assert_equal 3, updated_concert.rank
  end
end