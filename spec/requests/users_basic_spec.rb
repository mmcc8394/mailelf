require 'rails_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "UsersBasic", type: :request do
  before(:each) do
    create_basic_user
    basic_login
  end

  context 'can' do
    it 'show themselves' do
      get user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'edit non-role user data' do
      valid_user_edit(@basic)
    end

    it 'change their password' do
      valid_user_password_change(@basic)
    end
  end

  context 'cannot' do
    before(:each) { create_admin_user }
    after(:each) { expect_access_denied }

    it 'index' do
      get users_path
    end

    it 'show another user' do
      get user_path(@admin)
    end

    it 'new' do
      get new_user_path
    end

    it 'create' do
      post users_path, params: { user: { email: 'junk@domain.com', password: 'some-secret' } }
    end

    it 'edit another user' do
      get edit_user_path(@admin)
    end

    it 'update another user' do
      put user_path(@admin), params: { user: { email: 'junk@domain.com' } }
    end

    it 'edit another user password' do
      get edit_password_user_path(@admin)
    end

    it 'update another user password' do
      put update_password_user_path(@admin), params: { user: { password: 'new-secret', password_confirmation: 'new-secret' } }
    end

    it 'destroy' do
      delete user_path(@basic)
    end

    it 'edit its own role(s)' do
      put user_path(@basic), params: { user: { roles: [ 'admin' ] } }
    end
  end

  private

  def basic_login
    post login_path, params: { user: { email: @basic.email, password: @basic_password } }
    follow_redirect!
  end
end