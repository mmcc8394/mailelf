require 'rails_helper'

RSpec.describe Campaign, type: :model do
  before(:each) do
    @user = User.create!({ email: 'user@domain.com', password: 'some-secret', roles: [ 'basic' ] })

    @template = EmailTemplate.create!({ admin_id: @user.id,
                                        name: 'Some Template',
                                        subject: 'Some Subject',
                                        message: 'This is a message for %{first_name}.'
                                      })

    @campaign = Campaign.new({ admin_id: 1,
                               email_template_id: @template.id,
                               email_data: ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_valid.csv")
                             })
  end

  context 'valid' do
    it 'basics' do
      expect(@campaign.valid?).to eq(true)
    end

    it 'default throttle values' do
      expect(@campaign.instance_eval { @time_between_emails }).to eq(Campaign::DEFAULT_TIME_BETWEEN_EMAILS)
      expect(@campaign.instance_eval { @max_daily_emails }).to eq(Campaign::DEFAULT_MAX_DAILY_EMAILS)
    end

    it 'default throttle values' do
      @campaign = Campaign.new({ admin_id: 1,
                                 email_template_id: @template.id,
                                 email_data: ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_valid.csv"),
                                 time_between_emails: 99,
                                 max_daily_emails: 999
                               })

      expect(@campaign.instance_eval { @time_between_emails }).to eq(99)
      expect(@campaign.instance_eval { @max_daily_emails }).to eq(999)
    end
  end

  context 'invalid' do
    it 'email_template_id is nil' do
      @campaign.update({ email_template_id: nil })
      expect(@campaign.errors[:email_template_id]).to include('is not a number')
    end

    it 'email_template_id is 0' do
      @campaign.update({ email_template_id: 0 })
      expect(@campaign.errors[:email_template_id]).to include('must be greater than 0')
    end

    it 'email data missing' do
      @campaign.update({ email_data: nil })
      expect(@campaign.errors[:email_data]).to include("can't be blank")
    end

    it 'admin_id is nil' do
      @campaign.update({ admin_id: nil })
      expect(@campaign.errors[:admin_id]).to include('is not a number')
    end

    it 'admin_id is 0' do
      @campaign.update({ admin_id: 0 })
      expect(@campaign.errors[:admin_id]).to include('must be greater than 0')
    end

    it 'emails_queued is negative' do
      @campaign.update({ emails_queued: -1 })
      expect(@campaign.errors[:emails_queued]).to include('must be greater than or equal to 0')
    end
  end

  context 'csv file has correct data for template' do
    it 'missing key in csv file' do
      @template.update({ message: 'This is an error %{error}.' })
      @campaign.valid?
      expect(@campaign.errors[:email_data]).to include('CSV file missing key(s)')
    end

    it 'blank value in CSV file' do
      @campaign.email_data = ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_blank_value.csv")
      @campaign.valid?
      expect(@campaign.errors[:email_data]).to include('CSV file missing key(s)')
    end

    it 'missing email field' do
      @campaign.email_data = ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_with_no_email_field.csv")
      @campaign.valid?
      expect(@campaign.errors[:email_data]).to include('email field required in CSV file')
    end

    it 'bad email value in CSV file' do
      @campaign.email_data = ActionDispatch::Http::UploadedFile.new(tempfile: "#{Rails.root}/spec/fixtures/files/template_bad_email.csv")
      @campaign.valid?
      expect(@campaign.errors[:email_data]).to include('invalid email(s) in CSV file')
    end
  end

  context 'sending mails' do
    include ActiveJob::TestHelper

    before(:each) { clear_enqueued_jobs }

    it 'queues emails' do
      @campaign.send_emails
      expect(enqueued_jobs.size).to eq(2)
    end

    it 'first email is correct text' do
      @campaign.send_emails
      perform_enqueued_jobs
      expect(BulkMailer.deliveries.count).to eq(2)
      expect(BulkMailer.deliveries.first.body.encoded).to match('This is a message for Jane.')
    end

    it 'emails queued' do
      @campaign.send_emails
      expect(@campaign.emails_queued).to eq(2)
    end
  end
end
