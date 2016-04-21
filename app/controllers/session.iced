passport       = require "passport"
CouchStrategy  = require "passport-couch"
Base           = require "../models/base"


login = (req, res) ->
  res.rendr "sessions/new", pageTitle: "Login"

logout = (req, res) ->
  req.logout()
  res.redirect "/"


class Strategy extends CouchStrategy
  authRedirects:
    successRedirect: "/admin"
    failureRedirect: "/login"
    failWithError: true

  parseConfig: Base.parseConfig

  constructor: (config) ->
    @User = require "../models/user"
    @User.setup config
    server = @parseConfig config
    super server
    @verify = passport.authenticate "couch", @authRedirects

  deserializeUser: (id, done) =>
    @User.find id, done


module.exports =
  login:    login
  logout:   logout
  Strategy: Strategy
