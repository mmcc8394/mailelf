require 'rails_helper'
require 'requests/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "/email_templates", type: :request do
  it 'allows access' do
    create_basic_user
    basic_login
    get email_templates_path
    expect(response).to be_successful
  end

  it 'denies access' do
    get email_templates_path
    expect(response).to_not be_successful
  end
end
