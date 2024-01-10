class ThredController < ApplicationController
    def index
        @threds = Thred.all
        render json: @threds, except:[:content, :followups]
    end

    def show
        @thread = Thred.find params[:id]
        render json: @thread.as_json(include: [:followups]) 
    end

    def create
        @thread = Thred.new( thread_params)
        @thread.upvotes = 0
        @thread.category = Category.find params[:thread][:category]
        if @thread.save
            render json: @thread
        else 
            render json: @thread.errors, status: :unprocessable_entity
        end
    end

    def followup
        @thread = Thred.find params[:id]
        @post = @thread.followups.new post_params
        @post.upvotes = 0
        if @post.save
            render json: @post
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
    end
    
    def update 
        @thread = Thred.find params[:id]
        if @thread.update thread_params
            render json: @thread, except: [:followups]
        else
            render json: @thread.errors, status: :unprocessable_entity
        end
    end
    def destroy
        @thread = Thred.find params[:id]
        @thread.destroy

        render json: @thread
    end

    private 
    def thread_params
        params.require(:thread).permit(:username, :content, :title)

    end
    def post_params
        params.require(:post).permit(:username, :content)
    end
end
