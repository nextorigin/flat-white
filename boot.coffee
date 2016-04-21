#!./node_modules/.bin/iced

url          = require "url"
Cradle       = require "cradle"
errify       = require "errify"
CloudantUser = require "cloudant-user"
CouchApp     = require "couchapp"
_security    = require "./_security-docs/_security"


## Couch server admin credentials
username = ""
password = ""
## URL, Database for blog
host     = ""
port     = 443
database = "blog"
## New admin user for blog
bloguser = ""
email    = ""
blogpass = ""
## design doc for blog app
ddoc_path = "./_design-docs/app.coffee"


## Boot
{log, error} = console
log "setting up couch connection to #{host}"
log "using database #{database}"

secure = !!/https/.exec host
auth   = {username, password}
conn   = new Cradle.Connection {host, port, secure, auth}
db     = conn.database database

ideally = errify (err) ->
  error err
  process.exit 1

await db.exists ideally defer exists
unless exists
  log "creating database #{database}"
  await db.create ideally defer res

log "adding _security document to database with admins", _security.admins
await db.save "_security", _security, ideally defer res

log "creating blog admin user #{bloguser}"
cloudantUser = new CloudantUser {host, port, secure, auth: {username, password}}
await cloudantUser.createWithMeta bloguser, blogpass, "blog", "admin", "_reader", "_writer", {email}, ideally defer res

log "testing blog database with user #{bloguser}"
testconn = new Cradle.Connection {host, port, secure, auth: username: bloguser, password: blogpass}
testdb   = testconn.database database
testname = (new Buffer "#{Math.random()}").toString "base64"

log "creating test document #{testname}"
await testdb.save testname, {testing: true}, ideally defer res
log "removing test document #{testname}"
await testdb.remove testname, ideally defer res

fullurl = "#{host}:#{port}/#{database}"
log "pushing #{ddoc_path} to #{fullurl}"
fullauthurl = url.parse fullurl
fullauthurl.auth = "#{username}:#{password}"
fullauthurl = url.format fullauthurl
ddoc = require ddoc_path
await CouchApp.createApp ddoc, fullauthurl, defer couchapp
await couchapp.push ideally defer res

log "database ready"