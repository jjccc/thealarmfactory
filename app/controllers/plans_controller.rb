class PlansController < ApplicationController

  # GET /plans
  def index
    @plans = Plan.order(:position).all
  end

end
