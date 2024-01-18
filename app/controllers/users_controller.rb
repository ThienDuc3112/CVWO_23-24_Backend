class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy]

  # GET /users
  def index
    @users = User.all
    render json: @users, except: [:password_digest, :verify_token, :email]
  end

  # GET /users/1
  def show
    render json: @user, except: [:password_digest, :verify_token, :email]
  end

  # POST /users
  def create
    @user = User.new(user_params)

    @user.username.downcase!
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      render json: @user, status: :created, location: @user, except: [:password_digest, :verify_token]
    else
      render json: @user.errors ,status: :unprocessable_entity
    end
  end

  # POST /users/login
  def login
    @user = find_user(params[:username].downcase)
    if @user
      if @user.authenticate_password params[:password]
        render json: {token: JWT.encode({
          id: @user.id,
          username: @user.username,
          exp: Time.now.to_i + 3600
        }, ENV["SECRET_KEY"], "HS256")}
      else 
        render json: {password: "Incorrect password"}, status: :unauthorized
      end
    else
      render json: {username: "No account found"}, status: :not_found
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    if @user && @user.authenticate_password(params[:password])
      @user.destroy!
      render json: :nothing, status: :no_content
    else
      render json: { message: "Not authenticated" }, status: :unauthorized
    end
  end

  def verify
    token = request.headers['Authorization']&.split(' ')&.last
    res = verify_token(token)
    if res.first 
      # render json: res.first
      @user = User.find(res.first["id"])
      render json: @user, except: [:password_digest, :email, :verify_token]
    else 
      render json: {message: res.last}, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find params[:id]
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email)
    end

    def find_user(login)
      User.where("username = :value OR email = :value", value: login).first
    end
    
    def verify_token(token)
      @decoded_token = JWT.decode(token, ENV["SECRET_KEY"])
      rescue JWT::ExpiredSignature
        return [nil, "Expired token"]
      rescue JWT::DecodeError
        return [nil, "Invalid token"]
      rescue => e
        return [nil, e&.message]
    end
end
