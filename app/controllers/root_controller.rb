class RootController < ApplicationController
  def index
    gon.username = ENV["MQTT_USERNAME"]
    gon.password = ENV["MQTT_PASSWORD"]
  end
end
