class ThredController < ApplicationController
    include Auth
    before_action :find_thread, only: %i[show upvote downvote update destroy followup]
    before_action :get_user, except: %i[index show show_by_user search]

    def index
        @threds = Thred.all
        render json: @threds, except:[:content, :followups], include: {user: {only: :username}}
    end

    def show
        # This is the most horrendous line of unreadable code I have written in this project
        render json: @thread.as_json(include: [followups: {include: [user:{only: :username}]}, user:{only: :username}])
    end

    def show_by_user
        @user = User.find params[:id]
        render json: @user.threds, include: [user: {only: :username}]
    end
    
    def search
        if params[:keyword].present?
            @keyword = params[:keyword]
            keywords = @keyword.split(/\s+/)
            conditions = Array.new(keywords.length, "(title LIKE ? OR content LIKE ?)").join(" AND ")
            values = Array.new(keywords.length, "%#{@keyword}%")
            @threads = Thred.where(conditions, *values.cycle(2))
        else
            @threads = []
        end
        render json: @threads
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
        @thread.user = @user
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
        @post.user = @user
        if @post.save
            render json: @post, include: [user: {only: :username}]
        else 
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def update 
        if @thread.user.id != @user.id && !@user.is_admin
            render json: {message: "Unauthorize"}, status: :unauthorized
        elsif @thread.update(thread_params)
            render json: @thread, except: [:followups]
        else
            render json: @thread.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if @thread.user.id != @user.id && !@user.is_admin
            render json:{message: "Unauthorize"}, status: :unauthorized
        else
            @thread.destroy
            render json: @thread
        end
    end

    

    private 
    def thread_params
        params.require(:thread).permit(:content, :title)
    end
    
    def post_params
        params.require(:post).permit(:content)
    end

    def find_thread
        @thread = Thred.find(params[:id])
    end
end