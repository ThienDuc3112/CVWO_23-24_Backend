module Auth
    def verify_token(token)
      @decoded_token = JWT.decode(token, ENV["SECRET_KEY"])
      rescue JWT::ExpiredSignature
        return [nil, "Expired token"]
      rescue JWT::DecodeError
        return [nil, "Invalid token"]
      rescue => e
        return [nil, e&.message]
    end

  def get_user 
    token = request.headers['Authorization']&.split(' ')&.last
    res = verify_token(token)
    if res.first 
      @user = User.find(res.first["id"])
    else 
      render json: {message: res.last}, status: :unauthorized
    end
  end
end