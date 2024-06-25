class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: Settings.user.maxium_name_length }
  validates :email, presence: true, length: { maximum: Settings.user.maxium_email_length },
                    format: { with: /#{Settings.global.email_regex}/i }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: Settings.user.minium_password_length }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost:
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)

    remember_digest
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def session_token
    remember_digest || remember
  end
end
