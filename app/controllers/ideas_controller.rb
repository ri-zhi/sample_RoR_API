class IdeasController < ApplicationController
    def index
        columns = "ideas.id, ideas.body, categories.name as category_name"
        @ideas = params.has_key?(:category_name) ?
            Idea.select(columns).joins(:category).where(:categories => {:name => params[:category_name]}) :
            Idea.select(columns).joins(:category)
        return render :status => :not_found if @ideas.empty?
        render :json => { :data => @ideas }
    end

    def create
        ActiveRecord::Base.transaction do
            begin
                [:category_name, :body].each do |k|
                    raise "パラメータ不足" if !params.has_key?(k) || params[k].empty?
                end
                @categories = Category.select("id").where(:categories => {:name => params[:category_name]})
                if @categories.empty?
                    @category = Category.new(:name => params[:category_name])
                    @category.valid?
                    @category.save
                    @categories = Category.select("id").where(:categories => {:name => params[:category_name]})
                end
                @idea = Idea.new(:body => params[:body], :category_id => @categories.first.id)
                @idea.valid?
                @idea.save
            rescue => e
                logger.error e
                ActiveRecord::Rollback
                return render :status => :unprocessable_entity
            end
        end
        render :status => :created
    end
end
