CloudantQuery =
  index:
    default_field:
      enabled: true
      ## supported analzers: https://docs.cloudant.com/search.html#analyzers
      ## TODO: localize with config
      analyzer: "english"
    fields: ["tags", "title", "body"]
  ddoc: "keyword"
  type: "text"
  name: "keyword"


module.exports = CloudantQuery
