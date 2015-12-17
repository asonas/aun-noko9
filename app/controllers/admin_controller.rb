class AdminController < ApplicationController

  def index
    gon.announcements = Announcement.all
    gon.username = ENV["MQTT_USERNAME"]
    gon.password = ENV["MQTT_PASSWORD"]
  end
end
