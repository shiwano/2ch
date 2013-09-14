moment = require 'moment'

util = require './util'

module.exports = class BbsMenu
  reStrAtag: '<A HREF=(http:\\/\\/[^/]+(2ch.net|bbspink.com)\\/[^/]+\\/)>([^<>]+)<\\/A>'

  constructor: ->
    @menuUrl = 'http://menu.2ch.net/bbsmenu.html'
    @updatedAt = null
    @_bbsUrls = {}

  update: (done) ->
    @fetch (error, res) =>
      return done error if error

      atags = res.body.text.match(new RegExp(@reStrAtag, 'ig'))
      reAtag = new RegExp(@reStrAtag, 'i')

      atags.forEach (atag) =>
        matches = atag.match reAtag
        url = matches[1]
        name = matches[3]
        return if name is '2ch総合案内'
        @_bbsUrls[name] = url

      @updatedAt = moment()
      done?()

  fetch: (done) ->
    util.requestGet(@menuUrl).end done

  getBbsUrl: (bbsName) ->
    @_bbsUrls[bbsName] or null
