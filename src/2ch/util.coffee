request = require 'superagent'
encoding = require 'encoding'

requestParser = (res, done) ->
  res.text = ''
  res.setEncoding 'binary'
  res.on 'data', (chunk) -> res.text += chunk
  res.on 'end', ->
    done null,
      byteLength: Buffer.byteLength res.text, 'binary'
      text: exports.convertToUtf8 res.text

exports.requestGet = (url) ->
  request.get(url).parse(requestParser).set
    'User-Agent': 'Monazilla/1.00 (node-2ch)'

exports.convertToUtf8 = (cp932) ->
  encoding.convert(cp932, 'utf-8', 'cp932').toString()

exports.escapeRegExpChars = (str) ->
  str.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")
