class Player
  include Mongoid::Document
  field :kills, type: Integer
  field :deaths, type: Integer
  field :assists, type: Integer
  field :last_hits, type: Integer
  field :denies, type: Integer
  field :gold, type: Integer
  field :level, type: Integer
  field :gold_per_min, type: Integer
  field :xp_per_min, type: Integer
  field :ultimate_state, type: Integer
  field :ultimate_cooldown, type: Integer
  field :respawn_timer, type: Integer
  field :position_x, type: Integer
  field :position_y, type: Integer
  field :net_worth, type: Integer
  field :items, type: Array
  field :hero, type: Integer

  belongs_to :team
end
