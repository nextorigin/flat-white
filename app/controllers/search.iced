errify = require "errify"


exports.index = (req, res) ->
  Post    = require "../models/post"
  tag     = req.query.tag
  keyword = req.query.q
  error   = (err) -> res.render '500', pageTitle: "Error: #{err}"
  ideally = errify error

  if tag then await Post.findAllByTag tag, ideally defer posts
  else        await Post.findAllByKeyword keyword, ideally defer posts

  res.render 'blog/search',
    pageTitle: 'Search'
    posts: posts
