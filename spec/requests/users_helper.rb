module UsersHelper
  def create_admin_user
    @admin_password = 'admin-secret'
    @admin = User.create!({ email: 'admin@domain.com', password: @admin_password, roles: [ 'admin' ] })
  end

  def create_basic_user
    @basic_password = 'basic-secret'
    @basic = User.create!({ email: 'basic@domain.com', password: @basic_password, roles: [ 'basic' ] })
  end

  def expect_user_shown(user)
    expect(response.body).to include('User Details')
    expect(response.body).to include(user.email)
  end

  def verify_success_and_follow
    expect(response).to have_http_status(302)
    follow_redirect!
  end

  def verify_success_and_follow_with_text(text)
    verify_success_and_follow
    expect(response.body).to include(text)
  end

  def valid_user_edit(user)
    put user_path(user), params: { user: { email: 'new-email@domain.com' } }
    verify_success_and_follow_with_text('User info updated.')
    expect(User.find_by_id(@basic.id).try(:email)).to eq('new-email@domain.com')
  end

  def valid_user_password_change(user)
    put update_password_user_path(user), params: { user: { password: 'new-secret', password_confirmation: 'new-secret' } }
    verify_success_and_follow_with_text('User password changed.')
    expect(User.find_by_id(user.id).authenticate('new-secret')).to be_truthy
  end

  def expect_access_denied
    verify_success_and_follow_with_text('Access denied. You must login as an authorized user.')
  end
end