class UsersController < ApplicationController
  before_action :authenticate, except: [:create]
  # GET /users/1
  # GET /users/1.json
  def show
    render json: @current_user, except: :password_digest
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, except: :password_digest, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @current_user.update(user_params)
      head :no_content
    else
      render json: @current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.destroy

    head :no_content
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :username)
    end
end
