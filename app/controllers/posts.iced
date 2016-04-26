Xanax  = require "xanax"
errify = require "errify"


class PostsController extends Xanax
  constructor: (config) ->
    @Post    = require "../models/post"
    @Post.setup config

    super Model: @Post, name: config.name

  render: (res, path, response) =>
    res.format
      html: =>
        switch path
          when "#{@name}/create", "#{@name}/update", "#{@name}/patch", "#{@name}/delete"
            return res.redirect "/#{@name}"

        if Array.isArray response
          wrapper = {}
          wrapper[@name] = response

        res.rendr path, wrapper or response

      default: =>
        res.rendr path, response

  index: (req, res, next) ->
    res.locals.pageTitle = "Posts"
    super

  new: (req, res, next) ->
    res.locals.pageTitle = "New Post"
    super

  read: (req, res, next) ->
    res.locals.pageTitle = "#{res.locals.record.title}"
    super

  edit: (req, res, next) ->
    res.locals.pageTitle = "Edit Post: #{res.locals.record.title}"
    super

  editWithPen: (req, res, next) =>
    res.locals.pageTitle = "Edit Post: #{res.locals.record.title}"
    @respond res, "posts/edit_withpen", res.locals.record

  more: (req, res, next) =>
    res.locals.pageTitle = "Older Posts"
    ideally = errify next
    {page}  = req.params
    page    = Number page

    await @Model.findAllByAttribute "date", 10, {skip: (page - 1) * 10}, ideally defer records
    @respond res, "blog/index", records...

  postError: (err, req, res, next) =>
    {referer}  = req.headers
    previous   = referer?[(referer.lastIndexOf "/")..]
    previous or= "/error"

    res.statusCode or= err.status or 500
    @respond res, "#{@name}#{previous}", notice: "Error: #{err}"


module.exports = PostsController
