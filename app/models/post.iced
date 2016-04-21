errify = require "errify"
Base   = require "./base"
utils  = require "../utils"
extend = (require "util")._extend


class Post extends Base
  @configure "Post",
    "title",
    "body",
    "tags",
    "date"

  @findAllByDate: (limit, options, cb) =>
    selection = {limit, include_docs: true, descending: true}
    extend selection, options
    @db.view "app/postsByDate", selection, cb

  @tags: (cb) =>
    ideally = errify cb
    await @db.view "app/tags", {group: true}, ideally defer rows
    tags = (row.key for row in rows)
    cb null, tags

  @findAll: (options = {}, cb = ->) ->
    (cb = options) and options = {} if typeof options is "function"
    ideally = errify cb
    selection = key: @className, include_docs: true, reduce: false
    extend selection, options

    await @db.view "app/byType", selection, ideally defer rows
    cb null, @makeRecords rows

  @findAllByTag: (tag, options, cb) =>
    selection = key: tag
    extend selection, options
    @db.view "app/tags", selection, cb

  @findAllByKeyword: (keyword, options, cb) =>
    selection = selector: $text: keyword
    extend selection, options
    @db.post "_find", selection, cb

  constructor: (attrs = {}) ->
    attrs.id   = utils.doDashes attrs.title or ""
    attrs.date = (new Date).toISOString()
    super attrs

  update: ->
    @id = utils.doDashes @title
    super

  save: ->
    @tags = @tags.split "," if @tags and not Array.isArray @tags
    @tags[i] = tag.trim().toLowerCase() for tag, i in @tags
    super


module.exports = Post
