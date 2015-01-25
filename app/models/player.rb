class Player
  include Mongoid::Document
  #id is account_id
  field :player_slot, type: Integer
  field :hero, type: String
  field :item_0, type: Integer
  field :item_1, type: Integer
  field :item_2, type: Integer
  field :item_3, type: Integer
  field :item_4, type: Integer
  field :item_5, type: Integer
  field :kills, type: Integer
  field :deaths, type: Integer
  field :assists, type: Integer
  field :gold, type: Integer
  field :last_hits, type: Integer
  field :denies, type: Integer
  field :level, type: Integer
  field :gold_per_min, type: Integer
  field :xp_per_min, type: Integer
  field :hero_damage, type: Integer
  field :tower_damage, type: Integer
  field :hero_healing, type: Integer
  field :level, type: Integer
  field :gold_spent, type: Integer

  embedded_in :match
end
