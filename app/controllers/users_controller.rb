class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You've created a new user."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      # redirect_to back to new.html
      render :new
    end
  end

  def update
    @user = User.friendly.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path
    else
      redirect_to edit_user_path(@user)
    end
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username, :image)
    end

end
