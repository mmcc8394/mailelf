class EmailTemplatesController < ApplicationController
  before_action :verify_logged_in
  before_action :set_email_template, only: [ :show, :edit, :update, :destroy ]
  before_action :prevent_archived, only: [ :edit, :update, :destroy ]

  def index
    @email_templates = EmailTemplate.all.order(:name)
  end

  def show
    flash[:alert] = 'This template has been archived. It cannot be used in new campaigns.' if @email_template.archived?
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

  def destroy
    redirect_to email_templates_url, notice: "Email template was successfully #{@email_template.destroy}."
  end

  private

  def prevent_archived
    redirect_to email_templates_path, notice: "Cannot #{params[:action]} an archived template." if @email_template.archived
  end

  def set_email_template
    @email_template = EmailTemplate.find(params[:id])
  end

  def email_template_params
    params.require(:email_template).permit(:name, :subject, :message)
  end
end
