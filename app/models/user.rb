class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword

  field :username, type: String
  field :email, type: String
  field :password_digest, type: String
  field :steam_id, type: Integer
  field :steam_id_32, type: Integer
  field :steam_pic, type: String
  field :steam_nickname, type: String

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :password, confirmation: true, length: {minimum: 8}, on: :create
  validates :password_confirmation, presence: true, length: {minimum: 8}, on: :create

  has_many :proplayers
  has_and_belongs_to_many :matches

  has_secure_password

  # resync match data for all users
  # this could take a while.....
  def self.resync_match_data
    User.all.each do |u|
      MatchHistoryJob.new.perform(u.steam_id, true, u.id)
    end
  end

end
