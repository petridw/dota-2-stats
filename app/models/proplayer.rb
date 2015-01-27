class Proplayer
  include Mongoid::Document

  field :aliases, type: Array
  field :teams, type: Array
  field :tier, type: Integer
  
end
