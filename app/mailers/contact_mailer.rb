class SupportMailer < ApplicationMailer
  # layout "user_mailer"  # css is not showing up properly when using a layout

  def contact_us_email(registration)
    @registration = registration
    attachments.inline['logo_handwriting.png'] = File.read('app/assets/images/logo_handwriting.png')

    mail(to: @registration.email, subject: "Markafy - Contact Us Email")
  end
end
