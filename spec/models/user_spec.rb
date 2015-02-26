require 'rails_helper'

RSpec.describe User, :type => :model do

  before(:each) do
    @user = User.new(username: "dwp171", email: "petridw", password: "12345", password_confirmation: "12345")
  end

  after(:each) do
    User.delete_all
  end

  it "validates presence of username" do
    @user.username = nil
    expect(@user.valid?).to eq(false)
  end

  it "validates uniqueness of username" do
    @dupeUser = User.create(username: "dwp171", email: "blah@blah.com", password: "abcdefg", password_confirmation: "abcdefg")

    expect(@user.valid?).to eq(false)
  end

  it "validates presence of password" do
    @user.password = nil
    expect(@user.valid?).to eq(false)
  end

  it "validates presence of password confirmation" do
    @user.password_confirmation = nil
    expect(@user.valid?).to eq(false)
  end

  it "validates matching password and password confirmation" do
    @user.password = "1234567"
    @user.password_confirmation = "aaaaa"
    expect(@user.valid?).to eq(false)
  end

  it "authenticates user with correct password" do
    expect(@user.authenticate("123456")).to eq(false)
  end

end
