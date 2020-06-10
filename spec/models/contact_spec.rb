require 'rails_helper'

RSpec.describe Contact, type: :model do
  before(:each) { @contact = Contact.new({ email: 'contact@example.com' }) }

  context 'valid' do
    before(:each) { @contact.save! }

    it 'basic create' do
      expect(Contact.find(@contact.id)).to be_truthy
    end

    it 'sets default do_not_email' do
      expect(Contact.find(@contact.id).do_not_email?).to eq(false)
    end

    it 'generates a GUID' do
      expect(Contact.find(@contact.id).guid.downcase).to match(/[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}/)
    end
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

    it 'duplicate email' do
      @contact.save!
      tmp_contact = Contact.new({ email: @contact.email })
      tmp_contact.valid?
      expect(tmp_contact.errors[:email]).to include('has already been taken')
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
