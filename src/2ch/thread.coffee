_ = require 'lodash'
{EventEmitter2} = require 'eventemitter2'

util = require './util'
Bbs = require './bbs'
Message = require './message'

module.exports = class Thread extends EventEmitter2
  constructor: (@bbs, @number, @title='') ->
    @messages = []
    @lastModified = null
    @byteLength = 0
    @lastIndex = 0
    @_ended = false

  isEnded: ->
    @_ended

  toString: ->
    rawStrings = (m.rawString for m in @messages)
    rawStrings.join('\n') + '\n'

  update: (done, force=false) ->
    @fetch (error, res) =>
      if error
        @emit 'error', error
        return done? error

      switch res.status
        when 200, 206
          @_updateOnSuccess res, done
        when 302 # dat 落ち
          @_ended = true
          @emit 'end', @title
          done? null, []
        when 304 # 更新なし
          if @messages.length >= 1000
            @_ended = true
            @emit 'end', @title
          done? null, []
        when 416 # 削除？
          @emit 'reload', @title
          @update done, true
        else
          error = new Error("Unknown Status: #{res.status}")
          @emit 'error', error
          done? error

    , force

  _updateOnSuccess: (res, done) ->
    @lastModified = res.headers['last-modified']

    if res.status is 200
      @byteLength = res.body.byteLength
      @messages = []
      @emit 'begin', @title
    else
      @byteLength += res.body.byteLength

    rawMessages = res.body.text.trim().split('\n')
    messages = rawMessages.map (m, i) => new Message(m, i + @messages.length + 1)
    @messages = @messages.concat messages
    newMessages = _.filter @messages, (m) => m.number > @lastIndex
    @lastIndex = @messages.length
    @emit 'update', newMessages

    if _.isEmpty(newMessages) and @messages.length >= 1000
      @_ended = true
      @emit 'end', @title

    done? null, newMessages

  fetch: (done, force=false) ->
    url = @bbs.getThreadUrl @number
    req = util.requestGet(url)

    if force
      req.set('Accept-Encoding', 'gzip')
    else
      req.set('Accept-Encoding', if @lastModified? then 'identify' else 'gzip')
      req.set('If-Modified-Since', @lastModified) if @lastModified
      req.set('Range', "bytes=#{@byteLength}-") if @byteLength > 0

    req.end done
