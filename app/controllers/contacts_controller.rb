class ContactsController < ApplicationController
  def unsubscribe
    @contact = Contact.find_by_guid(params[:guid])
    if @contact
      @contact.set_do_not_email
      flash[:notice] = 'Successfully unsubscribed.'
    else
      flash[:alert] = 'Unable to find email account.'
    end
  end
end
