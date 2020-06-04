class BulkMailer < ApplicationMailer
  def send_mail
    @template = params[:template]
    @data = params[:data]
    @to_email = params[:data].delete(:email)

    mail(to: @to_email, subject: @template.subject)
  end
end