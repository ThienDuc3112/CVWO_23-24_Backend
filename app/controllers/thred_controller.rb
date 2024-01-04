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
        @post.thread = Thred.new
        @post.thread.category = Category.find(params[:post][:category])
        if @post.thread.save
            @post.upvotes = 0
            p @post
            if @post.save
                render json: @post
            else
                render json: @post.errors.full_messages, status: :unprocessable
            end
        else
            render json: @post.thread, status: :unprocessable
        end
    end
    
    private 
    def post_params
        params.require(:post).permit(:username, :title, :content)
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
