# require "source-map-support/register"
FlatWhite = require "./app"
config    = require "./config"


flatwhite = new FlatWhite
  address: process.env.OPTIK_PRIVATE_IP
  config:  config

flatwhite.listen()
