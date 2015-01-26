class Match
  include Mongoid::Document

  #id is match_id
  field :radiant_win, type: Boolean
  field :duration, type: Integer
  field :start_time, type: Integer
  field :error, type: String

  embeds_many :players
end
