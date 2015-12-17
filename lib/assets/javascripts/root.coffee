class Subscriber
  constructor: (topic) ->
    @client = new Paho.MQTT.Client("m11.cloudmqtt.com", 33563, "web_" + parseInt(Math.random() * 100, 10));
    console.log topic
    @topic = topic

  connect: ->
    options =
      useSSL: true
      userName: gon.username
      password: gon.password
      onFailure: (e) =>
        console.log
      onSuccess: =>
        console.log "connect"
        @client.subscribe(@topic)

    @client.connect options

  setMessageArrivedCallback: (callback) ->
    @client.onMessageArrived = callback

class Messenger
  constructor: (params) ->
    @messages = ko.observableArray(gon.messages)
    @snsSubscriver = new Subscriber("social-stream/tweet")
    @createSubscriber = new Subscriber("announcements/create")
    @deleteSubscriber = new Subscriber("announcements/delete")
    @subscribe()
    @announcements = ko.observableArray gon.announcements
    @message = ko.observable(@announcements()[1])
    @displayAnnouncement()

  displayAnnouncement: =>
    setInterval =>
      message = @announcements.shift()
      @message(message)
      @announcements.push(message)

    , 15000

  replaceMessage = =>
  ko.bindingHandlers.fadeInText = update: (element, valueAccessor) ->
    $(element).hide()
    ko.bindingHandlers.html.update element, valueAccessor
    $(element).fadeIn()

  subscribe: ->
    console.log  "subscrive"
    @snsSubscriver.setMessageArrivedCallback (message) =>
      message = message.payloadString
      @messages.unshift(JSON.parse(message))

    @createSubscriber.setMessageArrivedCallback (message) =>
      message = message.payloadString
      console.log "ann.cre", message
      @announcements.push(message)

    @deleteSubscriber.setMessageArrivedCallback (message) =>
      message = message.payloadString
      console.log "ann.del", message
      @announcements.remove(message)

    @snsSubscriver.connect()
    @createSubscriber.connect()
    @deleteSubscriber.connect()

$ ->
  messenger = new Messenger()
  ko.applyBindings messenger
