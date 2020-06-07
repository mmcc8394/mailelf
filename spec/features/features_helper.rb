module FeatureHelpers
  def create_user
    User.create!(email: 'user@example.com', password: 'password', roles: [ 'admin' ])
  end

  def login
    visit '/'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'login'
  end
end