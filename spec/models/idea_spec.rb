require "rails_helper"

RSpec.describe Idea, :type => :model do
  it "存在するcategory_id, bodyがある場合、有効である" do
    @category = Category.new(:name => "カテゴリー名")
    @category.save
    @idea = Idea.new(:body => "アイデアの内容", :category_id => 1)
    expect(@idea).to be_valid
  end

  it "category_idがない場合、無効である" do
    @idea = Idea.new(:body => "アイデアの内容", :category_id => nil)
    @idea.valid?
    expect(@idea.errors[:category_id]).to include("can't be blank")
  end

  it "存在しないcategory_id, bodyである場合、無効である" do
    @category = Category.new(:name => "カテゴリー名")
    @idea = Idea.new(:body => "アイデアの内容", :category_id => 2)
    @idea.valid?
    expect(@idea.errors[:category]).to include("must exist")
  end

  it "bodyがない場合、無効である" do
    @idea = Idea.new(:body => nil, :category_id => 1)
    @idea.valid?
    expect(@idea.errors[:body]).to include("can't be blank")
  end
end
