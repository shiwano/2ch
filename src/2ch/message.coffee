moment = require 'moment'

module.exports = class Message
  constructor: (@rawString, @number) ->
    [@name, @mail, dateAndId, body] = @rawString.split('<>')
    strs = dateAndId.split(' ')
    @postedAt = moment(strs[0..1].join(' '), 'YYYY/MM/DD HH:mm:ss')
    @tripId = strs[2].replace(/^ID:/, '')
    @body = body.trim()
