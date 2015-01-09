require 'test_helper'

class ProductionTest < ActiveSupport::TestCase
  def setup
    @productions_size_two = [
      Production.new(aggregate_score: 5, name: 'Foo1', genre: 'Foo1', category: 'Foo1', rank: 1),
      Production.new(aggregate_score: 3, name: 'Foo2', genre: 'Foo2', category: 'Foo2', rank: 2)
    ]
    @productions_size_three = [
      Production.new(aggregate_score: 7, name: 'Foo1', genre: 'Foo1', category: 'Foo1', rank: 1),
      Production.new(aggregate_score: 5, name: 'Foo2', genre: 'Foo2', category: 'Foo2', rank: 2),
      Production.new(aggregate_score: 3, name: 'Foo3', genre: 'Foo3', category: 'Foo3', rank: 3)
    ]
  end
  
  test 'should not save a production without a name' do
    production = Production.new
    assert_not production.save
  end
  
  test 'should only save productions with unique names' do
    production = Production.new(name: 'Ultra Music Festival')
    assert_not production.save
  end
  
  test 'average_in_category' do
    production = productions(:swift)
    production.average_in_category(5, 6, :people)
    assert_equal 5.25, production.people
  end
  
  # `before_destroy` callback
  
  test 'remove_production_from_production_rankings' do
    production = productions(:swift)
    production.send(:remove_production_from_production_rankings)
    assert_equal 1, productions(:edc).rank
    assert_equal 2, productions(:ultra).rank
  end
  
  # The remaining tests all test the method `update_rankings`.
  
  test 'update_rankings when size is one' do
    productions = [Production.new(aggregate_score: 5, name: 'Foo', genre: 'Foo', category: 'Foo', rank: 1)]
    productions[0].aggregate_score = 7
    updated_production = productions[0]
    updated_production.update_rankings(productions, 'increased')
    assert_equal 1, updated_production.rank
  end
  
  # Two productions involved in the next five tests.
  
  test 'update_rankings when size is two and the updated production surpasses a production' do
    updated_production = @productions_size_two[1]
    updated_production.aggregate_score = 7
    updated_production.update_rankings(@productions_size_two, 'increased')
    assert_equal 1, updated_production.rank
    assert_equal 2, @productions_size_two[0].rank
  end

  test 'update_rankings when size is two and the updated production increases to equate a production' do
    updated_production = @productions_size_two[1]
    updated_production.aggregate_score = 5
    updated_production.update_rankings(@productions_size_two, 'increased')
    assert_equal 1, updated_production.rank
    assert_equal 1, @productions_size_two[0].rank
  end
  
  test 'update_rankings when size is two and the updated production falls below a production' do
    updated_production = @productions_size_two[0]
    updated_production.aggregate_score = 2
    updated_production.update_rankings(@productions_size_two, 'decreased')
    assert_equal 1, @productions_size_two[1].rank
    assert_equal 2, updated_production.rank
  end
  
  test 'update_rankings when size is two and the updated production surpasses its equal' do
    @productions_size_two[1].rank = 1
    updated_production = @productions_size_two[0]
    updated_production.aggregate_score = 7
    updated_production.update_rankings(@productions_size_two, 'increased')
    assert_equal 1, updated_production.rank
    assert_equal 2, @productions_size_two[1].rank
  end
  test 'update_rankings when size is two and the updated production falls below its equal' do
    @productions_size_two[1].rank = 1
    updated_production = @productions_size_two[1]
    updated_production.aggregate_score = 2
    updated_production.update_rankings(@productions_size_two, 'decreased')
    assert_equal 1, @productions_size_two[0].rank
    assert_equal 2, updated_production.rank
  end
  
  # Three productions involved in the next eight tests.
  
  test 'update_rankings when size is three and the updated production surpasses two productions' do
    updated_production = @productions_size_three[2]
    updated_production.aggregate_score = 9
    updated_production.update_rankings(@productions_size_three, 'increased')
    assert_equal 1, updated_production.rank
    assert_equal 2, @productions_size_three[0].rank
    assert_equal 3, @productions_size_three[1].rank
  end
  
  test 'update_rankings when size is three and the updated production falls below two productions' do
    updated_production = @productions_size_three[0]
    updated_production.aggregate_score = 2
    updated_production.update_rankings(@productions_size_three, 'decreased')
    assert_equal 1, @productions_size_three[1].rank
    assert_equal 2, @productions_size_three[2].rank
    assert_equal 3, updated_production.rank
  end
  
  test 'update_rankings when size is three and the updated production falls below a production and equates another' do
    updated_production = @productions_size_three[0]
    updated_production.aggregate_score = 3
    updated_production.update_rankings(@productions_size_three, 'decreased')
    assert_equal 1, @productions_size_three[1].rank
    assert_equal 2, @productions_size_three[2].rank
    assert_equal 2, updated_production.rank
  end
  
  test 'update_rankings when size is three and the updated production surpasses its equal' do
    @productions_size_three[1].rank = 1
    updated_production = @productions_size_three[1]
    updated_production.aggregate_score = 9
    updated_production.update_rankings(@productions_size_three, 'increased')
    assert_equal 1, updated_production.rank
    assert_equal 2, @productions_size_three[0].rank
    assert_equal 3, @productions_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated production falls to last from being tied in first' do
    @productions_size_three[1].rank = 1
    updated_production = @productions_size_three[0]
    updated_production.aggregate_score = 2
    updated_production.update_rankings(@productions_size_three, 'decreased')
    assert_equal 1, @productions_size_three[1].rank
    assert_equal 2, @productions_size_three[2].rank
    assert_equal 3, updated_production.rank
  end
  
  test 'update_rankings when size is three and the updated production rises to second from being tied in last' do
    @productions_size_three[1].rank = 2
    updated_production = @productions_size_three[1]
    updated_production.aggregate_score = 6
    updated_production.update_rankings(@productions_size_three, 'increased')
    assert_equal 1, @productions_size_three[0].rank
    assert_equal 2, updated_production.rank
    assert_equal 3, @productions_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated production falls to second from being tied in first' do
    @productions_size_three[1].rank = 1
    updated_production = @productions_size_three[1]
    updated_production.aggregate_score = 6
    updated_production.update_rankings(@productions_size_three, 'decreased')
    assert_equal 1, @productions_size_three[0].rank
    assert_equal 2, updated_production.rank
    assert_equal 3, @productions_size_three[2].rank
  end
  
  test 'update_rankings when size is three and the updated production falls to last from being in a three way tie' do
    @productions_size_three[1].rank = 1
    @productions_size_three[2].rank = 1
    updated_production = @productions_size_three[2]
    updated_production.aggregate_score = 4
    updated_production.update_rankings(@productions_size_three, 'decreased')
    assert_equal 1, @productions_size_three[0].rank
    assert_equal 1, @productions_size_three[1].rank
    assert_equal 3, updated_production.rank
  end
  
  test 'update_rankings when size is three and no rank change is needed' do
    updated_production = @productions_size_three[2]
    updated_production.aggregate_score = 4
    updated_production.update_rankings(@productions_size_three, 'increased')
    assert_equal 1, @productions_size_three[0].rank
    assert_equal 2, @productions_size_three[1].rank
    assert_equal 3, updated_production.rank
  end
end