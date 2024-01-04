class ThredController < ApplicationController
    def index
        @threds = Thred.all
        render json: @threds.map {|thread| format_thread_preview(thread)}, except:[:content]
    end
    def show
        @thread = Thred.find params[:id]
        render json: formath_thread(@thread) 
    end
    
    def create
        @post = Post.new(post_params())
        @post.upvotes = 0
        @post.thred = Thred.new
        @post.thred.title = params[:post][:title]
        @post.thred.category = Category.find(params[:post][:category])
        if @post.thred.save
            p @post
            if @post.save
                render json: @post
            else
                render json: @post.errors.full_messages, status: :unprocessable
            end
        else
            render json: @post.thred, status: :unprocessable
        end
    end
    
    private 
    def post_params
        params.require(:post).permit(:username, :content)
    end
    def format_thread_preview(thread)
        post = thread.posts.first
        {
            id: thread.id,
            title: thread.title,
            username: post.username, 
            upvotes: post.upvotes,
            created_at: thread.created_at ,
        }
    end
    def formath_thread(thread) 
        {
            id: thread.id,
            title:thread.title,
            posts: thread.posts
        }
    end
end
