moment = require 'moment'

module.exports = class Message
  constructor: (@rawString, @number) ->
    [@name, @mail, dateAndId, body] = @rawString.split('<>')
    @body = body.trim()
    @_over1000 = false
    @_abone = false

    if dateAndId is 'Over 1000 Thread'
      @postedAt = moment()
      @tripId = ''
      @_over1000 = true
    else if dateAndId is 'あぼーん'
      @postedAt = moment()
      @tripId = ''
      @_abone = true
    else
      strs = dateAndId.split(' ')
      @postedAt = moment(strs[0..1].join(' '), 'YYYY/MM/DD HH:mm:ss')
      @tripId = strs[2].replace(/^ID:/, '')

  isOver1000Message: -> @_over1000
  isAboneMessage: -> @_abone
