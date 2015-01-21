class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true, length: {minimum: 8}
  validates :password_confirmation, presence: true, length: {minimum: 8}

  has_secure_password

end
