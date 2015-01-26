class Liveteam
  include Mongoid::Document
  field :name, type: String
  field :team_logo, type: String
  field :side, type: String
  field :kills, type: Integer
  field :tower_state, type: Integer
  field :barracks_state, type: Integer
  field :picks, type: Array
  field :bans, type: Array

  embedded_in :livematch
  embeds_many :liveplayers
end
