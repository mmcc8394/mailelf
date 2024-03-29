class BulkMailer < ApplicationMailer
  def send_mail
    @template = params[:template]
    @data = params[:data]
    @to_email = params[:data].delete(:email)
    @user = User.find(params[:user_id])
    @contact = Contact.find_by_email(@to_email)

    delivery_options = { user_name: @user.email,
                         password: Rails.application.credentials.email_passwords[password_symbol]
    }

    mail(to: @to_email,
         from: "TechUnwreck <#{@user.email}>",
         subject: @template.subject,
         delivery_method_options: delivery_options)
  end

  private

  def password_symbol
    @user.email.slice(/^[^@]*/).gsub('.', '_').to_sym
  end
end
