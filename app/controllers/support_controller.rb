class SupportController < ApplicationController
  def contact_us_email
    # @guest = []
    # SupportMailer.contact_us_email(@guest).deliver
    render :contact_us_confirmation, layout: "guest_pages/guest_layout"
  end
end
