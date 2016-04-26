express        = require "express"
passport       = require "passport"
Xanax          = require "xanax"

home           = require "./home"
search         = require "./search"
RSS            = require "./rss"
about          = require "./about"
session        = require "./session"
admin          = require "./admin"
admin_media    = require "./admin/media"
Posts          = require "./posts"
admin_messages = require "./admin/messages"
extend         = (require "util")._extend


class Routes
  constructor: (@config) ->
    @router = express.Router()
    @addRoutes()

  addRoutes: ->
    strategy = new session.Strategy @config
    passport.use strategy
    passport.serializeUser strategy.serializeUser
    passport.deserializeUser strategy.deserializeUser
    @router.use passport.initialize()
    @router.use passport.session()

    rss = new RSS @config

    @router.get  "/",                home.index
    @router.get  "/search",          search.index
    @router.get  "/rss.xml",         rss.index
    @router.get  "/about",           about.index
    @router.post "/about/message",   about.new_message
    # @router.get  "/projects",        projects.index

    @router.get  "/login",           session.login
    @router.post "/login",           strategy.verify
    @router.get  "/logout",          session.logout

    @router.get  "/admin",           @isAuthenticated, @isAdmin, admin.index
    @router.get  "/admin/media",     @isAuthenticated, @isAdmin, admin_media.index
    @router.get  "/admin/messages",  @isAuthenticated, @isAdmin, admin_messages.index

    posts  = new Posts @config
    @router.use "/#{posts.name}",    @isAuthenticated
    posts.router.get "/#{posts.name}/:id/pen", posts.find, posts.editWithPen
    posts.router.get "/page/:page",  posts.more
    @router.use posts.router #, posts.postError

    blog = new Posts extend {name: "blog"}, @config
    root = new express.Router
    root.get     "/:id",             blog.find, blog.read
    root.get     "*",                @redirectToRoot
    @router.use root

    this

  redirectToRoot: (req, res) -> res.redirect "/"

  health: (req, res) -> res.status(200).send "OK"

  isAuthenticated: (req, res, next) ->
    return res.redirect "/login" unless req.user
    next()

  isAdmin: (req, res, next) =>
    return next 401 unless req.user.admin
    next()


module.exports = Routes
