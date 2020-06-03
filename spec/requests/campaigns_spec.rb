require 'request_helper'

RSpec.describe "/campaigns", type: :request do
  before(:each) {
    create_basic_user
    @template = EmailTemplate.create!({ name: 'Some Name',
                                        subject: 'Some Subject',
                                        message: 'Some Message',
                                        admin_id: 1
                                      })
    @campaign = Campaign.create!({ email_template_id: @template.id,
                                   admin_id: 1
                                 })
  }

  it 'denies access' do
    get campaigns_path
    expect_access_denied
  end
end
