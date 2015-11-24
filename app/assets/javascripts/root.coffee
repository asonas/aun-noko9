class Subscriber
  constructor: (topic) ->
    @client = new Paho.MQTT.Client("m11.cloudmqtt.com", 33563, "web_" + parseInt(Math.random() * 100, 10));
    @topic = topic

  connect: ->
    options =
      useSSL: true
      userName: gon.username
      password: gon.password
      onSuccess: =>
        @client.subscribe(@topic)

    @client.connect options

  setMessageArrivedCallback: (callback) =>
    @client.onMessageArrived = callback

$ ->
  snsSubscriver = new Subscriber("social-stream/tweet")
  snsSubscriver.setMessageArrivedCallback( (message) ->
    console.log message.payloadString
  )
  snsSubscriver.connect()
