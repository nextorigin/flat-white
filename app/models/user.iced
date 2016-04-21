Spine        = require "spine"
CloudantUser = require "cloudant-user"
errify       = require "errify"
Base         = require "./base"


class User extends Spine.Model
  @defaults:
    roles: ["blog"]

  @configure "User",
    "name",
    "password",
    "email",
    "roles",
    "verified",
    "admin"

  @extend parseConfig: Base.parseConfig

  @setup: (config) ->
    server = @parseConfig config
    @cloudantUser = new CloudantUser server

  @find: (id, cb) ->
    ideally = errify cb

    await @cloudantUser.get id, ideally defer user
    [record] = @refresh user
    cb null, record.clone()

  @findAll: (cb) ->
    # get user by role design doc for npm, blog

  roles: (roles) ->
    return @_roles unless roles
    @admin    = "admin" in roles
    @verified = "_writer" in roles
    @_roles   = roles

  verify: (cb) ->
    @roles = ["blog", "_reader", "_writer"]
    @save cb

  attributes: (hideId) ->
    result = super()
    delete result.id if hideId
    result

  save: (cb = ->) =>
    ideally = errify cb
    wasNew  = @isNew()
    changed = @diff() unless wasNew
    {id}    = this

    if wasNew
      @[key] = value for key, value of @constructor.defaults when not @[key]?
      password = @password
      delete @password
      attrs = @attributes true
      await @constructor.cloudantUser.createWithMeta id, password, attrs, ideally defer result
    else unless changed
      await @constructor.cloudantUser.update id, (@attributes true), ideally defer result
      @password = null

    super()
    cb null, this

  remove: (cb = ->) =>
    ideally = errify cb
    await @cloudantUser.remove @id, ideally defer res
    super()
    cb()


module.exports = User
