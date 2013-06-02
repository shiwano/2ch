_ = require 'lodash'

util = require './util'

module.exports = class Bbs
  constructor: (@bbsMenu, @name) ->

  getThreadUrl: (number) ->
    "#{@bbsMenu.getBbsUrl @name}dat/#{number}.dat"

  fetch: (done) ->
    url = @bbsMenu.getBbsUrl(@name) + 'subject.txt'
    util.requestGet(url).end done

  fetchThreadHeader: (query, done) ->
    if @bbsMenu.updatedAt?
      @_fetchThreadHeader query, done
    else
      @bbsMenu.update (error) =>
        return done error if error
        url = @bbsMenu.getBbsUrl @name
        return done new Error('Unknown BBS name: ' + @name) unless url?
        @_fetchThreadHeader query, done

  searchThreadHeader: (query, text) ->
    if _.isRegExp(query)
      query = query.toString().replace /^\/|\/[igm]*$/g, ''
      reStr = "^([0-9]+)\\.dat<>(.*#{query}.*) \\(([0-9]+)\\)$"
    else
      query = util.escapeRegExpChars query
      reStr = "^([0-9]+)\\.dat<>(#{query}) \\(([0-9]+)\\)$"

    matches = text.match(new RegExp(reStr, 'img'))
    return null unless matches
    re = new RegExp(reStr, 'im')
    headers = matches.map (m) =>
      match = re.exec m
      {
        number: Number match[1]
        title: match[2]
        count: Number match[3]
      }
    headers = _.sortBy(headers, (h) -> h.count).filter((h) -> h.count < 1000)
    headers.reverse()
    headers[0]

  _fetchThreadHeader: (query, done) ->
    @fetch (error, res) =>
      return done error if error
      header = @searchThreadHeader query, res.body.text
      done null, header
