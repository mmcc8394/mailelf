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

  context 'denies access' do
    it 'index page' do
      get campaigns_path
      expect_access_denied
    end

    it 'create (send emails)' do
      post campaigns_path, params: { campaign: { email_template_id: @campaign.email_template_id, email_data: @campaign.email_data } }
      expect_access_denied
    end
  end
end
