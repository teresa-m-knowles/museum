class Exhibit

  attr_reader :name,
              :cost,
              :patron_attended

  def initialize(name, cost)
    @name = name
    @cost = cost
    @patron_attended = []
  end
end
