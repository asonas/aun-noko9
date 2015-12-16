class AdminController < ApplicationController

  def index
    @announcements = Announcement.all
  end
end
