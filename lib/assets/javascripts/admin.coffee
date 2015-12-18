class Subscriber
  constructor: (topic) ->
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
        console.log @topic
        @client.subscribe @topic

    @client.connect options

  sendMessage: (rawMessage) ->
    message = new Paho.MQTT.Message rawMessage
    message.destinationName = @topic
    @client.send message

  onConnectionLost = (responseObject) ->
    if responseObject.errorCode != 0
      console.log 'onConnectionLost:' + responseObject.errorMessage

class AdminViewModel
  constructor: () ->
    @announcements = ko.observableArray(gon.announcements)
    @subscriber = new Subscriber("aun/noko9")
    @bind()

  removeAnnouncement: (element) =>
    @announcements.remove(element)

    $.ajax
      url: "/announcements/#{element.id}"
      method: "DELETE"
    .done (res) =>
      @subscriber.sendMessage('{"announcement-delete": "' + res.announcement.message + '"}')

  restart: ->
    console.log "Restart all device"
    @subscriber.sendMessage('{"system": "restart"}')

  bind: ->
    $(".js-announcement-create-form").on "ajax:success", (xhr, data) =>
      console.log data
      @subscriber.sendMessage('{"announcement-create": "' + data.announcement.message + '"}')
      @announcements.push data.announcement
      $(".js-announcement-message").val("")

$ ->
  adminViewModel = new AdminViewModel
  ko.applyBindings adminViewModel
