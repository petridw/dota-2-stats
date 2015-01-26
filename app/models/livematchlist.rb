class Livematchlist
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :livematches
end
