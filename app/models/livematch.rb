class Livematch
  include Mongoid::Document

  #id = match_id
  field :spectators, type: Integer
  field :league_id, type: String
  field :series_type, type: Integer
  field :radiant_series_wins, type: Integer
  field :dire_series_wins, type: Integer
  field :duration, type: Float

  embeds_many :liveteams
  embedded_in :livematchlist

end
