class FollowupController < ApplicationController
    include Auth
    before_action :set_followup, only: [:show, :upvote, :downvote, :update, :destroy]
    before_action :get_user, except: :show

    def show
        render json: @followup
    end
    
    def upvote
        change_vote(1)
        end
    def downvote
        change_vote(-1)
        end
    
    def update
        if @followup.update(followup_params)
            render json: @followup
        else
            render json: @followup.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @followup.destroy
        render json: @followup
    end

    private
    def set_followup
        @followup = Followup.find(params[:id])
    end

    def followup_params
        params.require(:post).permit(:content, :username)
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