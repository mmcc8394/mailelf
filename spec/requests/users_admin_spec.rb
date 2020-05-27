require 'rails_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "UsersAdmin", type: :request do
  before(:each) do
    create_admin_user
    admin_login
  end

  context 'can' do
    before(:each) { create_basic_user }

    it 'index' do
      get users_path
      expect(response.body).to include(@admin.email)
      expect(response.body).to include(@basic.email)
    end

    it 'show another user' do
      get user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'load new user page' do
      get new_user_path
      expect(response).to have_http_status(200)
    end

    it 'create new user' do
      post users_path, params: { user: { email: 'new-email@domain.com', password: 'new-secret', roles: [ 'basic' ] } }
      verify_success_and_follow_with_text('New user created.')
      expect(User.all.order(:id).last.email).to eq('new-email@domain.com')
    end

    it 'load edit user page' do
      get edit_user_path(@admin)
      expect(response).to have_http_status(200)
    end

    it 'edit another user' do
      valid_user_edit(@basic)
    end

    it 'load edit password page' do
      get edit_password_user_path(@admin)
      expect(response).to have_http_status(200)
    end

    it 'change password' do
      valid_user_password_change(@admin)
    end

    it 'delete a non-admin user' do
      delete user_path(@basic)
      verify_success_and_follow_with_text('User deleted.')
      expect(User.find_by_id(@basic.id).deleted?).to eq(true)
    end
  end

  context 'cannot' do
    it 'delete an admin user' do
      new_admin = User.create!({ email: 'new-admin@domain.com', password: 'some-secret', roles: [ 'admin' ] })
      delete user_path(new_admin)
      expect_access_denied
    end

    pending 'remove admin role from user'

    it 'update password on user info edit' do
      put user_path(@admin), params: { user: { email: 'new-email@domain.com', password: 'ignore-password' } }
      verify_success_and_follow_with_text('User info updated.')
      expect(User.find_by_id(@admin.id).authenticate(@admin_password)).to be_truthy
    end

    it 'update user info on password change' do
      put update_password_user_path(@admin), params: { user: { email: 'ignore-email@domain.com', password: 'ignore-password' } }
      verify_success_and_follow_with_text('User password changed.')
      expect(User.find_by_id(@admin.id).email).to_not eq('ignore-email@domain.com')
    end

    it 'authorized but invalid operation (duplicate email but it could be anything)' do
      create_basic_user
      post users_path, params: { user: { email: @basic.email, password: 'new-secret' } }
      expect(response.body).to include('Email has already been taken')
    end
  end

  private

  def admin_login
    post login_path, params: { user: { email: @admin.email, password: @admin_password } }
    follow_redirect!
  end
end