require 'rails_helper'
require 'features/features_helper'

RSpec.configure do |c|
  c.include FeatureHelpers
end

feature 'login' do
  before(:each) { create_user }

  scenario 'successful login' do
    visit '/'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'login'
    expect(page).to have_content 'Successfully logged in.'
  end

  scenario 'failed login - bad email' do
    visit '/'
    fill_in 'Email', with: 'bad@example.com'
    fill_in 'Password', with: 'password'
    click_button 'login'
    expect(page).to have_content 'Invalid logins email.'
  end

  scenario 'failed login - bad password' do
    visit '/'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'bad_password'
    click_button 'login'
    expect(page).to have_content 'Invalid password.'
  end
end