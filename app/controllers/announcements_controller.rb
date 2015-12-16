class AnnouncementsController < ApplicationController

  def create
    a = Announcement.create(announcement_param)
    render json: {
      message: a.message
    }

  end

  def destroy
    a = Announcement.find params[:id]
    a.destroy

    render json: {
      message: "success",
      type: :success
    }
  end

  private
  def announcement_param
    params.require(:announcement).permit(:message)
  end
end
