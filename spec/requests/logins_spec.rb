require 'rails_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "Login", type: :request do
  before(:each) do
    create_basic_user
    get new_login_path
  end

  context 'valid login' do
    before(:each) { post login_path, params: { user: { email: @basic.email, password: @basic_password } } }

    it 'successful logins' do
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('Successfully logged in.')
    end

    it 'store user id in session' do
      expect(session[:user_id]).to eq(@basic.id)
    end

    it 'logs user out' do
      follow_redirect!
      delete login_path
      follow_redirect!
      expect(response.body).to include('Successfully logged out.')
      expect(session[:user_id]).to be_nil
    end
  end

  context 'logins errors' do
    it 'bad email' do
      post login_path, params: { user: { email: 'no-user@domain.com', password: @basic_password } }
      expect(response.body).to include('Invalid logins email.')
    end

    it 'bad password' do
      post login_path, params: { user: { email: @basic.email, password: 'bad-secret' } }
      expect(response.body).to include('Invalid password.')
    end
  end

  context 'password reset - can' do
    it 'view password reset email' do
      get lost_password_email_login_path
      expect(response.body).to include('Request Password Reset')
    end

    it 'create reset guid with a valid email' do
      request_password_reset
      verify_success_and_follow_with_text('Password reset email sent.')
      expect(User.find(@basic.id).password_reset_guid).to_not be_nil
    end

    it 'sends reset email' do
      expect { request_password_reset }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'reset_password_link', 'deliver_now', { args: [ @basic ] })
    end

    it 'use valid guid to reset password' do
      reset_password
      verify_success_and_follow_with_text('Password changed.')
      expect(User.find(@basic.id).password_reset_guid).to be_nil
    end

    it 'sends passwword changed email' do
      expect { reset_password }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'password_changed', 'deliver_now', { args: [ @basic ] })
    end

    it 'not logged in after password change' do
      reset_password
      expect(session[:user_id]).to be_nil
    end

    it 'login with new password after a reset' do
      reset_password
      post login_path, params: { user: { email: @basic.email, password: 'new-secret' } }
      expect(session[:user_id]).to eq(@basic.id)
    end
  end

  context 'password reset - cannot' do
    it 'request reset password with invalid email' do
      post request_password_reset_login_path, params: { user: { email: 'bad@email.com' } }
      verify_success_and_follow_with_text('Invalid email.')
    end

    it 'reset password without a guid' do
      put login_path, params: { user: { password: 'new-secret', confirm_password: 'new-secret' } }
      verify_success_and_follow_with_text('Invalid ID.')
    end

    it 'reset password with invalid guid (user has no guid)' do
      put login_path, params: { guid: '323a8c8f-06eb-471b-8d21-f7d51e8352fc', user: { password: 'new-secret', confirm_password: 'new-secret' } }
      verify_success_and_follow_with_text('Invalid ID.')
    end

    it 'reset password with invalid guid (user has guid)' do
      @basic.update_attribute(:password_reset_guid, SecureRandom.uuid)
      put login_path, params: { guid: '323a8c8f-06eb-471b-8d21-f7d51e8352fc', user: { password: 'new-secret', confirm_password: 'new-secret' } }
      verify_success_and_follow_with_text('Invalid ID.')
    end

    it 'reset password with an expired guid' do
      guid = SecureRandom.uuid
      @basic.update_attribute(:password_reset_guid, guid)
      put login_path, params: { guid: guid, user: { password: 'new-secret', confirm_password: 'new-secret' } }
      verify_success_and_follow_with_text('Password changed.')
      put login_path, params: { guid: guid, user: { password: 'new-secret', confirm_password: 'new-secret' } }
      verify_success_and_follow_with_text('Invalid ID.')
    end
  end

  private

  def request_password_reset
    post request_password_reset_login_path, params: { user: { email: @basic.email } }
  end

  def reset_password
    @basic.update_attribute(:password_reset_guid, SecureRandom.uuid)
    put login_path, params: { guid: @basic.password_reset_guid, user: { password: 'new-secret', confirm_password: 'new-secret' } }
  end
end
