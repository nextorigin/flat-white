path          = require "path"
override      = require "method-override"
responseTime  = require "response-time"
session       = require "express-session"
cookieParser  = require "cookie-parser"
assets        = require "connect-assets"
Skeleton      = require "nextorigin-express-skeleton"
ghm           = require "marked"
moment        = require "moment"
i18n          = require "i18n"
Routes        = require "./controllers/routes"


class FlatWhite extends Skeleton
  logPrefix: "(flat-white)"
  port: 3000

  constructor: (options) ->
    if process.env.NODE_ENV is "production"
      oneYear = 86400
      options.static or= root: (path.join process.cwd(), "public"), options: maxAge: oneYear
    else
      options.static or= (path.join process.cwd(), "public")

    options.urlencoded_extended = true
    @config = options.config
    @initLocale()

    super

  initLocale: ->
    i18n.configure
      #setup some locales - other locales default to en silently
      locales:["pt-br", "en"]

    #SET SYSTEM LANGUAGE
    i18n.setLocale @config.locale
    moment.locale @config.locale

  override: (req, res) ->
    return unless method = req.body?._method
    # look in urlencoded POST bodies and delete it
    delete req.body._method
    method

  loadMiddleware: ->
    super

    @debug "loading middleware"
    # method-override must come before any middleware that relies on METHOD
    @app.use override @override

    theme_dir   = @findTheme @config.theme
    subdirs     = ["assets/js", "assets/fonts", "assets/css", "assets/img"]
    assets_dirs = (path.join theme_dir, subdir for subdir in subdirs)
    @app.use assets paths: assets_dirs

    @app.use responseTime()

    views_dir = path.join theme_dir, "views"
    @app.set "views", views_dir
    @app.set "view options", pretty: true

    @app.use session
      name:   @config.session_name  or "flat-white"
      secret: @config.crypto_key
      store:  @config.session_store or session.MemoryStore reapInterval: 60000 * 10
      resave: false
      saveUninitialized: false

  localMiddleware: (req, res, next) =>
    res.locals.req         = req
    res.locals.session     = -> req.session if req.session?
    res.locals.token       = -> req.session._csrf if req.session?._csrf
    res.locals.user        = req.user
    res.locals.notice      = false
    res.locals.md          = ghm
    res.locals.moment      = moment
    res.locals.pageTitle   = @config.blog_title
    res.locals.config      = @config
    res.locals.__          = i18n.__
    res.locals.__n         = i18n.__n
    next()

  bindRoutes: ->
    @debug "loading routes"
    @app.use @localMiddleware
    @routes = new Routes @config
    @app.use @routes.router

  findTheme: (theme) =>
    subfolder = path.join "themes", theme
    if      local    = path.join process.cwd(), subfolder then local
    else if included = path.join __dirname, subfolder     then included
    else throw new Error "theme #{@config.theme} not found"


module.exports = FlatWhite
