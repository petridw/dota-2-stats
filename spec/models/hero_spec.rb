require 'rails_helper'

RSpec.describe Hero, :type => :model do
  
  before(:each) do
    @hero = Hero.new(name: "shadow friend")
  end

  describe ".name_upcase" do
    it "capitalizes the first letter of each word in the name" do
      expect(@hero.name_upcase).to eq("Shadow Friend")
    end
  end

end
