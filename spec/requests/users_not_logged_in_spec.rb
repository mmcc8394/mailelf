require 'rails_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "UsersNotLoggedIn", type: :request do
  context 'cannot' do
    before(:each) { create_basic_user }
    after(:each) { expect_access_denied }

    it 'index' do
      get users_path
    end

    it 'new' do
      get new_user_path
    end

    it 'create' do
      post users_path, params: { user: { email: 'new-user@domain.com', password: 'new-secret', roles: [ 'basic' ] } }
    end

    it 'edit' do
      get edit_user_path(@basic)
    end

    it 'update' do
      put user_path(@basic), params: { user: { email: 'new-email@domain.com' } }
    end

    it 'show' do
      get user_path(@basic)
    end

    it 'destroy' do
      delete user_path(@basic)
    end
  end
end