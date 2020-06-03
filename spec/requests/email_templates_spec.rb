require 'request_helper'

RSpec.describe "/email_templates", type: :request do
  before(:each) {
    create_basic_user
    @template = EmailTemplate.create!({ name: 'Some Name',
                                        subject: 'Some Subject',
                                        message: 'Some Message',
                                        admin_id: 1
                                      })
  }

  it 'denies access' do
    get email_templates_path
    expect_access_denied
  end

  context 'allows access' do
    before(:each) { basic_login }
    it 'index' do
      get email_templates_path
      expect(response).to be_successful
    end

    it 'edit' do
      get edit_email_template_path(@template)
      expect(response).to be_successful
    end
  end

  context 'archived templates' do
    before(:each) {
      @template.update!({ archived: true })
      basic_login
    }
    after(:each) { expect(response.code).to eq('302') }

    it 'edit' do
      get edit_email_template_path(@template)
      expect(flash[:notice]).to eq('Cannot edit an archived template.')
    end

    it 'update' do
      put email_template_path(@template), params: { email_template: { name: 'New Name' } }
      expect(flash[:notice]).to eq('Cannot update an archived template.')
    end

    it 'destroy' do
      delete email_template_path(@template)
      expect(flash[:notice]).to eq('Cannot destroy an archived template.')
    end
  end
end
