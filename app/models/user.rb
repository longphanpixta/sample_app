class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name,  presence: true, length: { maximum: MAXIMUM_USER_NAME_LENGTH }
  validates :email, presence: true, length: { maximum: MAXIMUM_USER_EMAIL_LENGTH }, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
