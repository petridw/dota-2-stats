class Team
  include Mongoid::Document
  field :name, type: String
  field :complete, type: Boolean
  field :side, type: String
  field :kills, type: Integer
  field :tower_state, type: Integer
  field :barracks_state, type: Integer

  belongs_to :match
  has_many :players
end
