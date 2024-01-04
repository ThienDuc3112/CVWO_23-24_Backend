class PostController < ApplicationController
    def index 
        @posts = Post.all
        render json: @posts, except: [:content]
    end
    def show 
        @post = Post.find(params[:id])
        render json: @post
    end
    def create
        @post = Post.new(post_params())
        @post.category = Category.find(params[:post][:category])
        @post.upvotes = 0
        p @post
        if @post.save
            render json: @post
        else
            render json: @post.errors.full_messages, status: :unprocessable
        end

    end

    private 
    def post_params
        params.require(:post).permit(:username, :title, :content)
    end
end
