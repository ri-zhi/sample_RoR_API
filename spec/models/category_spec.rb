require "rails_helper"

RSpec.describe Category, :type => :model do
  it "nameがある場合、有効である" do
    @category = Category.new(:name => "カテゴリー名")
    expect(@category).to be_valid
  end

  it "nameがない場合、無効である" do
    @category = Category.new(:name => nil)
    @category.valid?
    expect(@category.errors[:name]).to include("can't be blank")
  end
end
