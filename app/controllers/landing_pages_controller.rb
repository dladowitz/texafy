class LandingPagesController < ApplicationController

  def landing
    render layout: "guest_pages/guest_layout"
  end
end
