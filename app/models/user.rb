class User < ApplicationRecord
    has_secure_password
    before_create :set_defaults

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true
    validates :password_confirmation, presence:true, on: :create
    
    private 
    def set_defaults 
        self.activate = false
        loop do
            self.verify_token = SecureRandom.urlsafe_base64
            break unless User.exists?(verify_token: self.verify_token)
        end
    end
end
