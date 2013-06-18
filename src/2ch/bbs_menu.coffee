cheerio = require 'cheerio'
moment = require 'moment'

util = require './util'

module.exports = class BbsMenu
  constructor: ->
    @menuUrl = 'http://menu.2ch.net/bbsmenu.html'
    @updatedAt = null
    @_bbsUrls = {}

  update: (done) ->
    @fetch (error, res) =>
      return done error if error

      $ = cheerio.load res.body.text
      $("A[HREF*='2ch.net'],A[HREF*='bbspink.com']").each (index, elem) =>
        name = $(elem).text()
        url = $(elem).attr('HREF')
        return unless url.match /^http:\/\/[^/]+\/[^/]+\/$/
        return if name is '2ch総合案内'
        @_bbsUrls[name] = url

      @updatedAt = moment()
      done?()

  fetch: (done) ->
    util.requestGet(@menuUrl).end done

  getBbsUrl: (bbsName) ->
    @_bbsUrls[bbsName] or null
