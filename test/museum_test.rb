require './lib/museum'
require './lib/patron'
require './lib/exhibit'
require 'pry'

require 'minitest/autorun'
require 'minitest/pride'

class PatronTest < MiniTest::Test

  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_instance_of Museum, dmns
  end

  def test_it_has_a_name
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
  end

  def test_it_defaults_to_no_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.exhibits
  end

  def test_it_can_add_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, dead_sea_scrolls, imax], dmns.exhibits

  end

  def test_it_can_recommend_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")

    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")

    assert_equal [gems_and_minerals, dead_sea_scrolls], dmns.recommend_exhibits(bob)
    assert_equal [imax], dmns.recommend_exhibits(sally)

  end

  def test_it_defaults_to_no_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [], dmns.patrons
  end

  def test_it_can_admit_patrons

    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal [bob, sally], dmns.patrons
  end

  def test_it_can_show_the_patrons_by_exhibit

    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")

    sally = Patron.new("Sally", 20)
    sally.add_interest("Dead Sea Scrolls")

    dmns.admit(bob)
    dmns.admit(sally)

    expected = {gems_and_minerals => [bob],
                dead_sea_scrolls => [bob,sally],
                imax => []
              }
    assert_equal expected, dmns.patrons_by_exhibit_interest

  end

  def test_patron_does_not_attend_exhibit_if_money_is_insufficient

    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal 7, tj.spending_money

  end

  def test_patron_can_only_attend_exhibit_they_can_afford
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    assert_equal 0, bob.spending_money
  end

  def test_test_patron_attends_most_expensive_exhibit_first
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")

    dmns.admit(sally)

    assert_equal 5, sally.spending_money
  end

  def test_patrons_can_attend_multiple_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")

    dmns.admit(morgan)

    assert_equal 5, morgan.spending_money

  end

  def test_it_can_show_which_patrons_attended_each_exhibit

    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(sally)

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    dmns.admit(morgan)


    expected = {dead_sea_scrolls => [bob,morgan],
                imax => [sally],
                gems_and_minerals => [morgan]}

    assert_equal expected, dmns.patrons_of_exhibits

  end

  def test_it_can_show_revenue
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    imax = Exhibit.new("IMAX", 15)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(imax)
    dmns.add_exhibit(dead_sea_scrolls)

    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    bob = Patron.new("Bob", 10)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("IMAX")
    dmns.admit(bob)

    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(sally)

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    dmns.admit(morgan)

    assert_equal 35, dmns.revenue
  end

end
