class FollowupController < ApplicationController
    include Auth
    before_action :set_followup, only: %i[ show upvote downvote update destroy]
    before_action :get_user, except: %i[ show show_by_user ]

    def show
        render json: @followup, include: [user: {only: :username}]
    end
    
    def show_by_user
        @user = User.find params[:id]
        render json: @user.followups, include: [user:{only: :username}]
    end

    def upvote
        change_vote(1)
    end
    def downvote
        change_vote(-1)
    end

    def update
        if !@user.is_admin && @user.id != @followup.user.id
            render json: {message:"Unauthorized"}, status: :unauthorized
        elsif @followup.update(followup_params)
            render json: @followup
        else
            render json: @followup.errors, status: :unprocessable_entity
        end
    end

    def destroy
        if !@user.is_admin && @user.id != @followup.user.id
            render json: {message:"Unauthorized"}, status: :unauthorized
        else
            @followup.destroy
            render json: @followup
        end
    end

    private
    def set_followup
        @followup = Followup.find(params[:id])
    end

    def followup_params
        params.require(:post).permit(:content)
    end

    def change_vote(value)
        @followup.upvotes += value
        if @followup.save
            render json: :nothing, status: 204
        else 
            render json: @followup.errors, status: :unprocessable_entity
        end
    end
end