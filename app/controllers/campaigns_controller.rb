class CampaignsController < ApplicationController
  before_action :verify_logged_in

  # GET /campaigns
  def index
    @campaigns = Campaign.all.order('created_at desc')
  end

  # TODO: Implement this once we have stats on a campaign.
  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params.merge({ admin_id: current_user.id }))

    if @campaign.valid?
      @campaign.send_emails
      @campaign.save!

      redirect_to campaigns_path, notice: 'Campaign was successfully executed.'
    else
      render :new
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:email_template_id, :email_data)
  end
end
