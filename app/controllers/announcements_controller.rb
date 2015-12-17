class AnnouncementsController < ApplicationController

  def create
    a = Announcement.create(announcement_param)
    render json: {
      announcement: a
    }

  end

  def destroy
    a = Announcement.find params[:id]
    message = a.message
    a.destroy

    render json: {
      message: "success",
      type: :success,
      announcement: {
        message: message
      }
    }
  end

  private
  def announcement_param
    params.require(:announcement).permit(:message)
  end
end
