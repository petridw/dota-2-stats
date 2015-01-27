class Proplayer
  include Mongoid::Document

  field :aliases, type: Array
  field :teams, type: Array
  
end
