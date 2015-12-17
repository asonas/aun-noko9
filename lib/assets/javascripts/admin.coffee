class Subscriber
  constructor: (topic) ->
    console.log topic
    @client = new Paho.MQTT.Client("m11.cloudmqtt.com", 33563, "web_" + parseInt(Math.random() * 100, 10))

    @topic = topic
    @client.onConnectionLost = onConnectionLost

    options =
      useSSL: true
      userName: gon.username
      password: gon.password
      onFailure: (e) =>
        console.log e
      onSuccess: =>
        console.log 'onConnect'
        @client.subscribe @topic

    @client.connect options

  sendMessage: (rawMessage) ->
    message = new Paho.MQTT.Message rawMessage
    console.log @topic
    message.destinationName = @topic
    @client.send message

  onConnectionLost = (responseObject) ->
    if responseObject.errorCode != 0
      console.log 'onConnectionLost:' + responseObject.errorMessage

class AdminViewModel
  constructor: () ->
    @subscriber = new Subscriber("restart")
    console.log "hello"
    @announcements = ko.observableArray(gon.announcements)
    @createSubscriber = new Subscriber("announcements/create")
    @deleteSubscriber = new Subscriber("announcements/delete")
    @bind()

  restart: ->
    console.log "restart"
    @subscriber.sendMessage("restart")

  removeAnnouncement: (element) =>
    @announcements.remove(element)

    $.ajax
      url: "/announcements/#{element.id}"
      method: "DELETE"
    .done (res) =>
      console.log "done",res.announcement.message
      @deleteSubscriber.sendMessage res.announcement.message

  bind: ->
    $(".js-announcement-create-form").on "ajax:success", (xhr, data) =>
      console.log data
      @createSubscriber.sendMessage data.announcement.message
      @announcements.push data.announcement
      $(".js-announcement-message").val("")

$ ->
  adminViewModel = new AdminViewModel
  ko.applyBindings adminViewModel

  onMessageArrived = (message) ->
    console.log 'onMessageArrived:' + message.payloadString
