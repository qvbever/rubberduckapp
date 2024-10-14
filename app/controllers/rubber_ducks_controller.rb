class RubberDucksController < ApplicationController
  def index
    @rubber_ducks = Rubberduck.all
  end
end
