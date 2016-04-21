

DesignDoc =
  _id: "_design/app"

  views:
    byType:
      map: (doc) -> emit doc.type, null
      reduce: "_count"

    postsByDate:
      map: (doc) -> emit doc.date, null if doc.date

    tags:
      map: (doc) -> emit tag, null for tag in tags if {tags} = doc
      reduce: (keys, values) -> true

  # lists:
  #   people: (head, req) ->
  #     start headers: "Content-type": "text/html"
  #     send "<ul id=\"people\">\n"
  #     while row = getRow()
  #       send "\u0009<li class=\"person name\">" + row.key + "</li>\n"
  #     send "</ul>\n"

  # shows:
  #   person: (doc, req) ->
  #     headers: "Content-type": "text/html"
  #     body: "<h1 id=\"person\" class=\"name\">" + doc.name + "</h1>\n"

  validate_doc_update: (newDoc, oldDoc, userCtx) ->
    require = (field, message) ->
      message = message or "Document must have a " + field
      throw forbidden: message unless newDoc[field]

    require "title" if newDoc.type == "Post"


module.exports = DesignDoc
