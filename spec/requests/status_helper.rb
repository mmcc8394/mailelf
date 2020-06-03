module StatusHelper
  def verify_success_and_follow
    expect(response).to have_http_status(302)
    follow_redirect!
  end

  def verify_success_and_follow_with_text(text)
    verify_success_and_follow
    expect(response.body).to include(text)
  end

  def expect_access_denied
    expect(flash[:alert]).to include('Access denied')
    expect(response.code).to eq('302')
    expect(response.redirect_url).to include('access-denied')
  end
end