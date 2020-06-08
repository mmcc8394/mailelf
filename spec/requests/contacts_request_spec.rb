require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  context 'unsubscribe' do
    it 'valid guid' do
      contact = Contact.create!({ email: 'contact@example.com' })
      get unsubscribe_path(contact.guid)
      expect(response).to be_successful
      expect(flash[:notice]).to eq('Successfully unsubscribed.')
      expect(Contact.find(contact.id).do_not_email?).to eq(true)
    end

    it 'invalid guid' do
      contact = Contact.create!({ email: 'contact@example.com' })
      get unsubscribe_path('this-is-a-bad-guid')
      expect(response).to be_successful
      expect(flash[:alert]).to eq('Unable to find email account.')
    end
  end
end
