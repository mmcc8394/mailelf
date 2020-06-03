class BulkMailer < ApplicationMailer
  def send_mail
    @template = params[:template]
    @to_email = params[:data].delete("email")

    # quirk of serialization: turns symbols to strings - turn them back to symbols
    @data = params[:data].transform_keys(&:to_sym)

    mail(to: @to_email, subject: @template.subject)
  end
end