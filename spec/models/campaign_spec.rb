require 'rails_helper'

RSpec.describe Campaign, type: :model do
  before(:each) do
    @template = EmailTemplate.create!({ name: 'Some Template',
                                        subject: 'Some Subject',
                                        message: 'This is a message.',
                                        admin_id: 1
                                      })
    @campaign = Campaign.new({ email_template_id: @template.id, admin_id: 1 })
  end

  it 'valid' do
    expect(@campaign.save).to eq(true)
  end

  context 'invalid' do
    it 'email_template_id is nil' do
      @campaign.email_template_id = nil
      expect(@campaign).to_not be_valid
      expect(@campaign.errors[:email_template_id]).to include('is not a number')
    end

    it 'email_template_id is 0' do
      @campaign.email_template_id = 0
      expect(@campaign).to_not be_valid
      expect(@campaign.errors[:email_template_id]).to include('must be greater than 0')
    end

    it 'admin_id is nil' do
      @campaign.admin_id = nil
      expect(@campaign).to_not be_valid
      expect(@campaign.errors[:admin_id]).to include('is not a number')
    end

    it 'admin_id is 0' do
      @campaign.admin_id = 0
      expect(@campaign).to_not be_valid
      expect(@campaign.errors[:admin_id]).to include('must be greater than 0')
    end
  end
end
