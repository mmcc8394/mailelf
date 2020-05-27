require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before(:each) { @user = User.create!({ email: 'user@domain.com', password: 'some-secret', password_confirmation: 'some-secret', roles: [ 'basic' ] }) }

  context 'user creation' do
    before(:each) { @mail = UserMailer.welcome(@user) }

    it 'queues up welcome email' do
      email_queued?('welcome')
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'subject line' do
      expect(@mail.subject).to eq('New User Account Created')
    end

    it 'body' do
      expect(@mail.body.encoded).to match('Your account has been created.')
    end
  end

  context 'reset password request' do
    before(:each) do
      @user.update_attribute(:password_reset_guid, SecureRandom.uuid)
      @mail = UserMailer.reset_password_link(@user)
    end

    it 'queues up reset password email' do
      email_queued?('reset_password_link')
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'subject line' do
      expect(@mail.subject).to eq('Password Reset Link')
    end

    it 'body' do
      expect(@mail.body.encoded).to match(@user.password_reset_guid)
    end
  end

  context 'password changed (or reset)' do
    before(:each) { @mail = UserMailer.password_changed(@user) }

    it 'queues up changed password email' do
      email_queued?('password_changed')
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'subject line' do
      expect(@mail.subject).to eq('Your Password Has Been Changed')
    end

    it 'body' do
      expect(@mail.body.encoded).to match("If this wasn't you, please contact us immediately.")
    end
  end

  private

  def email_queued?(method)
    expect { @mail.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', method, 'deliver_now', { args: [ @user ] })
  end
end
