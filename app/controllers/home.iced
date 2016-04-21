errify = require "errify"


exports.index = (req, res, next) ->
  Post    = require "../models/post"
  error   = (err) -> res.render 'blog/index', pageTitle: "Error: #{err}", posts: []
  ideally = errify error

  await Post.tags ideally defer tags
  await Post.findAllByAttribute "date", 10, ideally defer posts

  res.render 'blog/index',
    pageTitle: 'Blog'
    tags:     tags.sort()
    posts:    posts
