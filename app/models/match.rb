class Match
  include Mongoid::Document
  include Mongoid::Timestamps

  field :spectators, type: Integer
  field :duration, type: Float

  has_many :teams
end
