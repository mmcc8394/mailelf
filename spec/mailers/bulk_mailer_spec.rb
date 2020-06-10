require "rails_helper"

RSpec.describe BulkMailer, type: :mailer do
  before(:each) do
    @user = User.create!({ email: 'user@domain.com', password: 'some-secret', roles: [ 'basic' ] })

    @template = EmailTemplate.create!({ admin_id: @user.id,
                                        name: 'Template 1',
                                        subject: 'Some Subject',
                                        message: 'This is a message for %{first_name}.'
                                      })

    @contact = Contact.create!({ email: 'someone@example.com' })
    @mail = BulkMailer.with(user_id: @user.id,
                            template: @template,
                            data: { email: @contact.email, first_name: 'Mark', last_name: 'Johnson' }).send_mail
  end

  it 'enqueues proper email' do
    expect { @mail.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
  end

  it 'to email' do
    expect(@mail.to).to eq([ 'someone@example.com' ])
  end

  it 'subject line' do
    expect(@mail.subject).to eq('Some Subject')
  end

  it 'body correct' do
    expect(@mail.body.encoded).to match('This is a message for Mark.')
  end
end