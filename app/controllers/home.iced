errify = require "errify"


class HomeController
  constructor: (@config) ->
    @Post = require "../models/post"

  index: (req, res, next) =>
    view    = "blog/index"
    error   = (err) -> res.render view, pageTitle: "Error: #{err}", posts: []
    ideally = errify error

    await @Post.tags ideally defer tags
    await @Post.findAllByAttribute "date", 10, ideally defer posts

    res.render view,
      pageTitle: @config.blog_title
      tags:      tags.sort()
      posts:     posts


module.exports = HomeController
