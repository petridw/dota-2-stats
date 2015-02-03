class Match
  include Mongoid::Document

  #id is match_id
  field :radiant_win, type: Boolean
  field :duration, type: Integer
  field :start_time, type: Integer
  field :error, type: String
  field :has_pro, type: Boolean
  field :syncing, type: Boolean

  has_and_belongs_to_many :users

  embeds_many :players
end
