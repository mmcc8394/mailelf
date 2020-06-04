require 'request_helper'

RSpec.describe "/campaigns", type: :request do
  before(:each) {
    create_basic_user
    @template = EmailTemplate.create!({ name: 'Some Name',
                                        subject: 'Some Subject',
                                        message: 'Some Message',
                                        admin_id: 1
                                      })

    @campaign = Campaign.new({ admin_id: 1,
                               email_template_id: @template.id,
                               email_data: ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_valid.csv")
                             })
  }

  it 'denies access' do
    get campaigns_path
    expect_access_denied
  end
end
