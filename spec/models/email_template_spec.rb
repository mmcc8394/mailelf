require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do
  before(:each) { @template = EmailTemplate.new({ name: 'Some Template',
                                                  subject: 'Some Subject',
                                                  message: 'This is a message.',
                                                  admin_id: 1
                                                }) }
  it 'valid' do
    expect(@template.save).to eq(true)
  end

  context 'invalid' do
    after(:each) { expect(@template.save).to eq(false) }

    it 'name is nil' do
      @template.name = nil
    end

    it 'name is blank' do
      @template.name = ''
    end

    it 'subject is nil' do
      @template.subject = nil
    end

    it 'subject is blank' do
      @template.subject = ''
    end

    it 'message is nil' do
      @template.message = nil
    end

    it 'message is blank' do
      @template.message = ''
    end

    it 'admin_id is nil' do
      @template.admin_id = nil
    end

    it 'admin_id is 0' do
      @template.admin_id = 0
    end
  end
end
