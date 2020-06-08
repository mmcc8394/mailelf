require 'rails_helper'

RSpec.describe Contact, type: :model do
  before(:each) { @contact = Contact.new({ email: 'contact@example.com' }) }

  it 'valid with default' do
    expect(@contact.save).to eq(true)
    expect(Contact.first.do_not_email).to eq(false)
  end

  context 'invalid' do
    it 'email nil' do
      @contact.update({ email: nil })
      expect(@contact.errors[:email]).to include("can't be blank")
    end

    it 'email blank' do
      @contact.update({ email: '' })
      expect(@contact.errors[:email]).to include("can't be blank")
    end

    it 'incorrect email format' do
      @contact.update({ email: 'contact@' })
      expect(@contact.errors[:email]).to include('invalid email format')
    end

    it 'do_not_email is nil' do
      @contact.update({ do_not_email: nil })
      expect(@contact.errors[:do_not_email]).to include('must be a boolean value')
    end
  end

  it 'set do_not_email' do
    @contact.save!
    @contact.set_do_not_email
    expect(Contact.find(@contact.id).do_not_email?).to eq(true)
  end
end
