class LoginsController < ApplicationController

  def new
    redirect_to root_path, alert: "Youre already logged in, silly." if logged_in?
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      login_user
    else
      flash[:alert] = 'Invalid logins email.'
      @user = User.new
      render :new
    end
  end

  def lost_password_email
    @user = User.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def request_password_reset
    @user = User.find_by_email(params[:user][:email])
    if @user
      send_reset_password_email
    else
      flash[:alert] = 'Invalid email.'
      redirect_to new_login_path
    end
  end

  def edit
    @user = User.by_password_guid(params[:guid])
    if @user.nil?
      flash[:alert] = 'Invalid ID.'
      redirect_to new_login_path
    end
  end

  def update
    @user = User.by_password_guid(params[:guid])
    if @user
      reset_password
    else
      flash[:alert] = 'Invalid ID.'
      redirect_to new_login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully logged out.'
  end

  private

  def login_user
    return if @user.nil?

    if @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Successfully logged in.'
    else
      flash[:alert] = 'Invalid password.'
      render :new
    end
  end

  def send_reset_password_email
    return if @user.nil?

    if @user.update({ password_reset_guid: SecureRandom.uuid })
      UserMailer.reset_password_link(@user).deliver_later
      redirect_to new_login_path, notice: 'Password reset email sent.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :lost_password_email
    end
  end

  def reset_password
    return if @user.nil?

    @user.password_reset_guid = nil
    if @user.update(password_reset_params)
      UserMailer.password_changed(@user).deliver_later
      redirect_to new_login_path, notice: 'Password changed.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :new
    end
  end

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
