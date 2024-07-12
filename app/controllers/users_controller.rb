class UsersController < ApplicationController

  def index
    @users = User.all
    respond_to do |format|
      format.json { render json: @users }
      format.html
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.json { render json: @user, status: :created }
        format.html { redirect_to users_url, notice: "User was successfully created." }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
        format.html { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def filter
    if params[:campaign_names].present?
      @users = User.get_user_by_campaign_name(params[:campaign_names])
    end

    respond_to do |format|
      format.json { render json: @users }
      format.html
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, campaigns_list: [:campaign_name, :campaign_id])
  end
end