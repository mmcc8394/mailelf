require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { @user = User.new({ email: 'user@domain.com', password: 'some-secret', password_confirmation: 'some-secret', roles: [ 'basic' ] }) }

  context 'successful CRUD operations' do
    it 'creates' do
      expect(@user.save).to eq(true)
    end

    it 'read' do
      @user.save!
      u = User.first
      expect(u.try(:email)).to eq(@user.email)
    end

    it 'update' do
      @user.save!
      expect(@user.update({ email: 'new_user@somedomain.com', password: 'new-secret', password_confirmation: 'new-secret' })).to eq(true)
    end

    it 'delete' do
      @user.save!
      expect(@user.destroy).to be_truthy
    end
  end

  context 'fails to create an invalid user' do
    after(:each) { expect(@user.save).to eq(false) }

    it 'blank email' do
      @user.email = ''
    end

    it 'nil email' do
      @user.email = nil
    end

    it 'blank password' do
      @user.password = @user.password_confirmation = ''
    end

    it 'nil password' do
      @user.password = @user.password_confirmation = nil
    end

    it 'password too short' do
      @user.password = @user.password_confirmation = 'abcde'
    end

    it 'mismatched password' do
      @user.password = 'bad-password'
    end

    it 'no confirmation password' do
      @user.password_confirmation = ''
    end

    it 'duplicate email' do
      @user.save
      @user = User.new({ email: 'user@domain.com', password: 'new-secret', password_confirmation: 'new-secret', roles: [ 'basic' ] })
    end
  end

  context 'fails to edit invalid user' do
    before(:each) { @user.save! }

    it 'blank email' do
      expect(@user.update({ email: '' })).to eq(false)
    end

    it 'nil email' do
      expect(@user.update({ email: nil })).to eq(false)
    end

    it 'too short password' do
      @user.update({ password: 'abcde' })
    end

    it 'nil password' do
      @user.update({ password: nil })
    end

    it 'mismatched password' do
      expect(@user.update({ password: 'new-password', password_confirmation: 'bad-password' })).to eq(false)
    end

    it 'duplicate email' do
      User.create!({ email: 'second@domain.com', password: 'new-secret', password_confirmation: 'new-secret', roles: [ 'basic' ] })
      expect(@user.update({ email: 'second@domain.com' })).to eq(false)
    end
  end

  context 'password reset' do
    before(:each) { @user.save! }

    it 'should be nil to start' do
      expect(@user.password_reset_guid).to be_nil
    end
  end

  context 'roles' do
    it 'has a single role' do
      @user.save!
      expect(User.first.basic?).to eq(true)
    end

    it 'has multiple roles' do
      @user.roles = %w(basic auditor)
      @user.save!
      expect(User.first.basic?).to eq(true)
      expect(User.first.auditor?).to eq(true)
    end

    it 'fails if nil roles' do
      @user.roles = nil
      expect(@user.save).to eq(false)
    end

    it 'fails if empty roles' do
      @user.roles = []
      expect(@user.save).to eq(false)
    end

    it 'fails if invalid role set' do
      @user.roles = [ 'junk_role' ]
      expect(@user.save).to eq(false)
    end
  end
end
