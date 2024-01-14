class CategoryController < ApplicationController
    def index 
        @categories = Category.all
        render json: @categories.map {|category| format_category(category)}
    end

    def show
        @category = Category.find params[:id]
        render json: @category.threds, except: [:content]
    end

    private 
    def format_category(category) 
        {
            id: category[:id],
            name: category[:name],
            description: category[:description],
            colour: category[:colour],
            postCount: category.threds.count
        }
    end
end
