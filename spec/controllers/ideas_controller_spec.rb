require "rails_helper"

RSpec.describe IdeasController, :type => :controller do
  describe "POST ideas" do
    it "post create 登録できた場合は201を返しデータが存在する" do
      post :create, :params => { :body => "タスク管理ツール", :category_name => "アプリ" }
      expect(response).to have_http_status :created

      get "index"
      expect(response).to have_http_status :ok
      json = JSON.parse(response.body)
      expect(json["data"][0]["id"]).to eq 1
      expect(json["data"][0]["body"]).to eq "タスク管理ツール"
      expect(json["data"][0]["category_name"]).to eq "アプリ"
    end

    it "post create bodyがない場合は422" do
      post :create, :params => { :body => nil, :category_name => "アプリ" }
      expect(response).to have_http_status :unprocessable_entity
    end

    it "post create category_nameがない場合は422" do
      post :create, :params => { :body => "タスク管理ツール", :category_name => nil }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe "GET ideas" do
    before do
      Category.new(:name => "アプリ").save
      Category.new(:name => "会議").save
      Idea.new(:body => "タスク管理ツール", :category_id => 1).save
      Idea.new(:body => "オンラインでブレスト", :category_id => 2).save
    end

    it "get index 全てを取得する場合" do
      get "index"
      expect(response).to have_http_status :ok
      json = JSON.parse(response.body)
      expect(json["data"][0]["id"]).to eq 1
      expect(json["data"][0]["body"]).to eq "タスク管理ツール"
      expect(json["data"][0]["category_name"]).to eq "アプリ"
    end

    it "get index category_nameを指定してデータが存在する場合" do
      get "index", :params => { :category_name => "会議" }
      expect(response).to have_http_status :ok
      json = JSON.parse(response.body)
      expect(json["data"][0]["id"]).to eq 2
      expect(json["data"][0]["body"]).to eq "オンラインでブレスト"
      expect(json["data"][0]["category_name"]).to eq "会議"
    end

    it "get index category_nameを指定してデータが存在しない場合は404" do
      get "index", :params => { :category_name => "思いつき" }
      expect(response).to have_http_status :not_found
    end
  end
end
