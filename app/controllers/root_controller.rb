class RootController < ApplicationController
  def index
    gon.username = ENV["MQTT_USERNAME"]
    gon.password = ENV["MQTT_PASSWORD"]

    auth = ENV['TWITTER_AUTH'].split(":")
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = auth[0]
      config.consumer_secret     = auth[1]
      config.access_token        = auth[2]
      config.access_token_secret = auth[3]
    end
    gon.messages = client.search("kosenconf", result_type: "recent").take(10).map{ |t| convert(t)  }
    gon.announcements = Announcement.all.map(&:message)
  end

  private
  def convert(t)
    {
      text: t.text,
      user: {
        name: t.user.name,
        screen_name: t.user.screen_name,
        profile_image_url: t.user.profile_image_url.to_s
      }
    }
  end
end
