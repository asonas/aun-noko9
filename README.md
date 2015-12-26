# Yet Another Aun Subscreen

## Deploy to Heroku

### Before action
You need to setup [aun-signage/aun-receiver](https://github.com/aun-signage/aun-receiver) to collect messages.
See [documents of aun-receiver](https://github.com/aun-signage/aun-receiver/blob/master/README.md) for detail.

## Create an application for aun-noko9

```
heroku create
```

### Set environment variables

#### Setup CloudMQTT

Specify the same MQTT broker as aun-signage/aun-receiver.
See your CloudMQTT console:

* MQTT_PASSWORD
* MQTT_URL
* MQTT_USERNAME

e.g.

```
heroku config:set MQTT_PASSWORD=username
heroku config:set MQTT_URL=tcp://foobar:baz.cloudmqtt.com:13563
heroku config:set MQTT_USERNAME=password
```

## TWITTER_AUTH
Credentials for twitter. Tokens should be concatenated with ':'.

```
TWITTER_AUTH=[Consumer key]:[Consumer secret]:[Access token]:[Access token secret]
```

## TWITTER_EXCLUDE_REGEXP

Regexp to exclude tweets from screen.

Example (to exclude RTs):

```
TWITTER_EXCLUDE_REGEXP=^RT
```

* TWITTER_EXCLUDE_REGEXP should be a regular expression


## TWITTER_EXCLUDE_SCREEN_NAME

Screen names to exclude from screen.

```
TWITTER_EXCLUDE_SCREEN_NAME=[Screen Names]
```

* TWITTER_EXCLUDE_SCREEN_NAME should be comma separated

## TWITTER_QUERY

Strings to track.

```
TWITTER_QUERY=kosenconf
```

* TWITTER_QUERY should be comma separated

## Deploy

```
git push heroku master
heroku run rake db:migrate
```

## Usage

You execute `heroku open` in terminal, Or `https://[Your Application Name].herokuapp.com/` with your web browser.

You will see all messages received.

### endpoint

#### /admin

* Setting announcement from your team.
* Restart all clients, Over the air.


## Development

Required environment variables:

* TWITTER_AUTH
* TWITTER_QUERY
* MQTT_URL
* MQTT_USERNAME
* MQTT_PASSWORD

```
bundle install
rake db:migrate
TWITTER_AUTH=foo:bar:baz:piyo TWITTER_QUERY=kosenconf dadada... rails server
```
