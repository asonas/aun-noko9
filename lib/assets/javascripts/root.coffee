class Subscriber
  constructor: (topic) ->
    @client = new Paho.MQTT.Client("m11.cloudmqtt.com", 33563, "web_" + parseInt(Math.random() * 100, 10));
    @topic = topic

  connect: ->
    options =
      useSSL: true
      userName: gon.username
      password: gon.password
      onFailure: (e) =>
        console.log e
      onSuccess: =>
        console.log "onConnect"
        console.log @topic
        @client.subscribe(@topic)

    @client.connect options

  setMessageArrivedCallback: (callback) ->
    @client.onMessageArrived = callback

class Messenger
  constructor: (params) ->
    @messages = ko.observableArray(gon.messages)
    @snsSubscriver = new Subscriber("social-stream/tweet")
    @subscriber = new Subscriber("aun/noko9")

    @subscribe()
    @announcements = ko.observableArray gon.announcements
    @message = ko.observable(@announcements()[1])
    @displayAnnouncement()

  displayAnnouncement: =>
    setInterval =>
      message = @announcements.shift()
      @message(message)
      @announcements.push(message)
    , 2000

  replaceMessage = =>
  ko.bindingHandlers.fadeInText = update: (element, valueAccessor) ->
    $(element).hide()
    ko.bindingHandlers.html.update element, valueAccessor
    $(element).fadeIn()

  subscribe: ->
    @snsSubscriver.setMessageArrivedCallback (message) =>
      console.log "Recieve message: #{message}"
      message = message.payloadString
      @messages.unshift(JSON.parse(message))

    @subscriber.setMessageArrivedCallback (message) =>
      message = message.payloadString
      console.log "Recieve message: #{message}"
      payload = JSON.parse(message)
      switch _.keys(payload)[0]
        when "system"
          location.reload()
        when "announcement-create"
          @announcements.push(_.values(payload)[0])
        when "announcement-delete"
          @announcements.remove(_.values(payload)[0])

    @snsSubscriver.connect()
    @subscriber.connect()

$ ->
  messenger = new Messenger()
  ko.applyBindings messenger
