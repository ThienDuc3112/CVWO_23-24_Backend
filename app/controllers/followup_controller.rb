class FollowupController < ApplicationController
    def show
        @followup = Followup.find params[:id]
        render json: @followup
    end
    def update
        @followup = Followup.find params[:id]
        if @followup.update followup_params
            render json: @followup
        else
            render json: @followup.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @followup = Followup.find params[:id]
        @followup.destroy

        render json: @followup
    end
    private
    def followup_params
        params.require(:post).permit(:content, :username)
    end
end
