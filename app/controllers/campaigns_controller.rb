class CampaignsController < ApplicationController
  before_action :verify_logged_in
  before_action :set_campaign, only: [ :show ]

  # GET /campaigns
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params.merge({ admin_id: current_user.id }))

    if @campaign.valid?
      
      redirect_to @campaign, notice: 'Campaign was successfully created.'
    else
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def campaign_params
    params.require(:campaign).permit(:email_template_id, :email_data)
  end
end
