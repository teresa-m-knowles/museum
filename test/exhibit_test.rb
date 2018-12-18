require './lib/exhibit'
require 'minitest/autorun'
require 'minitest/pride'

class ExhibitTest < MiniTest::Test

  def test_it_exists
    exhibit = Exhibit.new("Gems and Minerals", 0)
    assert_instance_of Exhibit, exhibit
  end

  def test_it_has_a_name
    exhibit = Exhibit.new("Gems and Minerals", 0)

    assert_equal "Gems and Minerals", exhibit.name
  end

  def test_it_has_a_cost
    exhibit = Exhibit.new("Gems and Minerals", 0)

    assert_equal 0, exhibit.cost

  end

end
