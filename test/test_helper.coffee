fs = require 'fs'
chai = require 'chai'
chai.use require('sinon-chai')

global.expect = chai.expect
global.sinon = require 'sinon'
global.nock = require 'nock'

exports.require = (path) =>
  require "#{__dirname}/../src/#{path}"

fixtureCache = {}

exports.getFixture = (name, encoding) =>
  return fixtureCache[name] if fixtureCache[name]
  result = fs.readFileSync "./test/fixtures/#{name}"
  fixtureCache[name] = result
  result

nock('http://menu.2ch.net').persist()
  .get('/bbsmenu.html')
  .reply(200, exports.getFixture('bbsmenu.html'), {'Content-Type': 'text/html'})

nock('http://engawa.2ch.net').persist()
  .get('/sakura/subject.txt')
  .reply(200, exports.getFixture('subject.txt'), {'Content-Type': 'text/plain'})

nock('http://engawa.2ch.net').persist()
  .get('/sakura/dat/1231808850.dat')
  .matchHeader('Accept-Encoding', 'gzip')
  .reply 200, exports.getFixture('1231808850.dat'),
    'Last-Modified': 'Thu, 13 Jun 2013 12:00:00 GMT'
    'Content-Type': 'text/plain'

nock('http://engawa.2ch.net').persist()
  .get('/sakura/dat/1231808850.dat')
  .matchHeader('Accept-Encoding', 'identify')
  .matchHeader('If-Modified-Since', 'Thu, 13 Jun 2013 12:00:00 GMT')
  .matchHeader('Range', 'bytes=3703-')
  .reply 206, exports.getFixture('1231808850_2.dat'),
    'Last-Modified': 'Thu, 13 Jun 2013 13:00:00 GMT'
    'Content-Type': 'text/plain'
