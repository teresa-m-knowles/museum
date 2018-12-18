require './lib/patron'
require './lib/exhibit'
require 'pry'

class Museum

  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(person)
    recommended = exhibits.select do |exhibit|

      person.interests.include?(exhibit.name)
    end
    recommended
  end

  def recommended_patron_for_exhibit(exhibit)
      @patrons.select do |patron|
        patron.interests.include?(exhibit.name)
    end
  end



  def admit(person)
    @patrons << person
    possibilities = recommend_exhibits(person)


    possibilities.reject! do |possible_exhibit|
      possible_exhibit.cost > person.spending_money
    end

    sorted_ascending = possibilities.sort_by do |possible_exhibit|
      possible_exhibit.cost
    end

    sorted = sorted_ascending.reverse


    sorted.each do |possible_exhibit|
      pay_for_exhibit(person, possible_exhibit)
    end
  end


  def pay_for_exhibit(person, exhibit)
    if person.spending_money >= exhibit.cost
    person.spending_money = person.spending_money - exhibit.cost
    exhibit.patron_attended << person
    end
  end


  def patrons_by_exhibit_interest
    hash = Hash.new
    @exhibits.each do |exhibit|
      hash[exhibit] = recommended_patron_for_exhibit(exhibit)
    end
    hash
  end

  def patrons_of_exhibits
    hash = Hash.new

    @exhibits.each do |exhibit|
      hash[exhibit] = exhibit.patron_attended
    end
    hash

  end

  def revenue
    revenue = 0
    patrons_of_exhibits.each do |exhibit, patrons|
      revenue += exhibit.cost * patrons.length
    end
    revenue
  end


end
