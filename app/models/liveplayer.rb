class Liveplayer
  include Mongoid::Document

  #id is account_id
  field :player_slot, type: Integer
  field :hero, type: String
  field :item_0, type: String
  field :item_1, type: String
  field :item_2, type: String
  field :item_3, type: String
  field :item_4, type: String
  field :item_5, type: String
  field :kills, type: Integer
  field :deaths, type: Integer
  field :assists, type: Integer
  field :gold, type: Integer
  field :last_hits, type: Integer
  field :denies, type: Integer
  field :gold_per_min, type: Integer
  field :xp_per_min, type: Integer
  field :level, type: Integer
  field :respawn_timer, type: Integer
  field :net_worth, type: Integer

  embedded_in :liveteam
end
