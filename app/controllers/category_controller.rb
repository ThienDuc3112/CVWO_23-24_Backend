class CategoryController < ApplicationController
    include Auth
    before_action :get_user, only: %i[create destroy]
    def index 
        @categories = Category.all
        render json: @categories.map {|category| format_category(category)}
    end

    def show
        @category = Category.find params[:id]
        render json: @category.threds, except: [:content], include: [user: {only: :username}]
    end

    def create
        if !@user.is_admin
            render json: {message: "You are not an admin, you can't create a new category"}, status: :unauthorized
            return
        end
        @category = Category.new(category_params)
        if @category.save
            render json: @category
        else
            render json: @category.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if !@user.is_admin
            render json: {message: "You are not an admin, you can't create a new category"}, status: :unauthorized
            return
        end
        @category = Category.find(params[:id])
        @category.destroy
        render json: @category
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

    def category_params
        params.require(:category).permit(:name, :description, :colour)
    end
end
