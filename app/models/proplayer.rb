class Proplayer
  include Mongoid::Document

  #id is player's 32-bit steam ID
  field :aliases, type: Array
  field :teams, type: Array
  field :tier, type: Integer
  field :last_league, type: String
  field :last_active, type: DateTime

  belongs_to :user
  
end
