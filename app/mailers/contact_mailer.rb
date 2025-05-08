class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_message.subject
  #
  default to: "marcus.kyrk2@gmail.com"

  def contact_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail(
      subject: "New message from contact form",
      reply_to: email
    )
  end
end
