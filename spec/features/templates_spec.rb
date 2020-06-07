require 'rails_helper'
require 'features/features_helper'

RSpec.configure do |c|
  c.include FeatureHelpers
end

feature 'templates' do
  before(:each) do
    create_user
    login
  end

  scenario 'create template' do
    visit '/email_templates/new'
    fill_in 'Name', with: 'Template One'
    fill_in 'Subject', with: 'Email Subject'
    fill_in 'Message', with: 'This is a test.'
    click_button 'submit'
    expect(page).to have_content 'Email template was successfully created.'
  end

  scenario 'edit template' do
    template = EmailTemplate.create!({ name: 'Template One',
                                       subject: 'Email Subject',
                                       message: 'This is a test.',
                                       admin_id: User.first.id
                                     })

    visit "/email_templates/#{template.id}/edit"
    fill_in 'Name', with: 'New Template Name'
    click_button 'submit'
    expect(page).to have_content 'Email template was successfully updated.'
    expect(EmailTemplate.find(template.id).name).to eq('New Template Name')
  end
end