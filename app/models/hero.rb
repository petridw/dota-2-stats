class Hero
  include Mongoid::Document
  field :name, type: String


  def name_upcase
    name.split.map(&:capitalize).join(' ')
  end
end
