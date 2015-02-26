require 'rails_helper'

RSpec.describe League, :type => :model do
  
  describe "#update_leagues" do
    it "update_leagues is a class method" do
      expect(League).to respond_to :update_leagues
    end
  end

end
