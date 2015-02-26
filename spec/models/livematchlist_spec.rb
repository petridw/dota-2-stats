require 'rails_helper'

RSpec.describe Livematchlist, :type => :model do
  describe "#clean" do
    it "clean is a class method" do
      expect(Livematchlist).to respond_to :clean
    end
  end
end
