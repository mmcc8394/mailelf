require 'rails_helper'
require 'features/features_helper'

RSpec.configure do |c|
  c.include FeatureHelpers
end

feature 'campaigns' do
  include ActiveJob::TestHelper

  before(:each) do
    create_user

    EmailTemplate.create!({ admin_id: User.first.id,
                            name: 'Some Template',
                            subject: 'Some Subject',
                            message: 'This is a message for %{first_name}.'
                          })

    login
  end

  scenario 'create campaign' do
    visit '/campaigns/new'
    attach_file('campaign_email_data', "#{Rails.root}/spec/fixtures/files/template_valid.csv")
    select('Some Template', from: 'campaign_email_template_id')
    click_button 'submit'
    expect(page).to have_content 'Campaign was successfully executed'
    expect(enqueued_jobs.size).to eq(3)
  end
end