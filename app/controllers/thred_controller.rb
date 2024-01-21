class ThredController < ApplicationController
    include Auth
    before_action :find_thread, only: %i[show upvote downvote update destroy followup]
    before_action :get_user, except: %i[index show]

    def index
        @threds = Thred.all
        render json: @threds, except:[:content, :followups]
    end
    def show
        render json: @thread.as_json(include: [:followups]) 
    end

    def upvote
        @thread.increment!(:upvotes)
        head :no_content
    end

    def downvote
        @thread.decrement!(:upvotes)
        head :no_content
    end

    def create
        @thread = Thred.new(thread_params)
        @thread.upvotes = 0
        @thread.category = Category.find params[:thread][:category]
        if @thread.save
            render json: @thread
        else 
            render json: @thread.errors, status: :unprocessable_entity
        end
    end

    def followup
        @post = @thread.followups.new(post_params)
        @post.upvotes = 0
        if @post.save
            render json: @post
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def update 
        if @thread.update(thread_params)
            render json: @thread, except: [:followups]
        else
            render json: @thread.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @thread.destroy
        render json: @thread
    end

    def search
        if params[:keyword].present?
            @keyword = params[:keyword]
            keywords = @keyword.split(/\s+/)
            conditions = Array.new(keywords.length, "(title LIKE ? OR username LIKE ? OR content LIKE ?)").join(" AND ")
            values = Array.new(keywords.length, "%#{@keyword}%")
            @threads = Thred.where(conditions, *values.cycle(3))
        else
            @threads = []
        end
        render json: @threads
    end

    private 
    def thread_params
        params.require(:thread).permit(:username, :content, :title)
    end
    
    def post_params
        params.require(:post).permit(:username, :content)
    end

    def find_thread
        @thread = Thred.find(params[:id])
    end
end