RSS    = require "rss"
errify = require "errify"


class RssController
  constructor: (@config) ->
    @Post = require "../models/post"

  index: (req, res, next) =>
    ideally = errify next
    feed = new RSS
      title:       @config.blog_title
      description: @config.blog_description
      feed_url:    @config.feed_url
      site_url:    @config.site_url
      image_url:   @config.site_image_url
      author:      @config.site_author

    await @Post.findAll ideally defer posts
    for post in posts
      feed.item
        title: post.title
        url:   "#{@config.site_url}/#{post.id}"

    res.type "rss"
    res.send feed.xml()


module.exports = RssController
