class EmailTemplatesController < ApplicationController
  before_action :verify_logged_in
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  def index
    @email_templates = EmailTemplate.all
  end

  def show
  end

  def new
    @email_template = EmailTemplate.new
  end

  def create
    @email_template = EmailTemplate.new(email_template_params)
    @email_template.admin_id = current_user.id

    if @email_template.save
      redirect_to @email_template, notice: 'Email template was successfully created.'
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @email_template.update(email_template_params)
      redirect_to @email_template, notice: 'Email template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /email_templates/1
  def destroy
    @email_template.destroy
    redirect_to email_templates_url, notice: 'Email template was successfully destroyed.'
  end

  private
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    def email_template_params
      params.require(:email_template).permit(:name, :subject, :message)
    end
end
