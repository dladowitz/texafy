class SupportController < ApplicationController
  def contact_us_email
    @options = {subject: params[:subject],
                name:    params[:name],
                email:   params[:email],
                message: params[:message]
               }
    SupportMailer.contact_us_email(@options).deliver
    render "support_mailer/contact_us_confirmation", layout: "guest_pages/guest_layout"
  end
end
