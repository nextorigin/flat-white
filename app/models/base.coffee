CouchModel = require "spine-couch"


class Base extends CouchModel
  @parseConfig: (config, server = {}) ->
    settings = ["host", "port", "database"]
    server[setting] = config["db_#{setting}"] for setting in settings
    server.auth =
      username: config.db_username
      password: config.db_password
    server

  @setup: (config) ->
    server = @parseConfig config
    super server


module.exports = Base
