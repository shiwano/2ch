moment = require 'moment'

module.exports = class Message
  constructor: (@rawString, @number) ->
    [@name, @mail, dateAndId, body] = @rawString.split('<>')
    @body = body.trim()

    if dateAndId is 'Over 1000 Thread'
      @postedAt = moment()
      @tripId = ''
      @_over1000 = true
    else
      strs = dateAndId.split(' ')
      @postedAt = moment(strs[0..1].join(' '), 'YYYY/MM/DD HH:mm:ss')
      @tripId = strs[2].replace(/^ID:/, '')
      @_over1000 = false

  isOver1000Message: ->
    @_over1000
