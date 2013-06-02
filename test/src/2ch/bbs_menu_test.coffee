helper = require '../../test_helper'

BbsMenu = helper.require '2ch/bbs_menu'

describe 'BbsMenu', ->
  beforeEach ->
    @bbsMenu = new BbsMenu()

  describe '#update', ->
    it 'should update BBS url data', (done) ->
      @bbsMenu.update =>
        expect(Object.keys(@bbsMenu._bbsUrls).length).to.be.equal 851
        done()

    it 'should update @updatedAt time', (done) ->
      @bbsMenu.update =>
        updatedAt = @bbsMenu.updatedAt
        @bbsMenu.update =>
          expect(@bbsMenu.updatedAt).to.be.above updatedAt
          done()

    it 'should emit update event', (done) ->
      @bbsMenu.on 'update', -> done()
      @bbsMenu.update()

  describe '#fetch', ->
    it 'should return the BBS menu html which is decoded from cp932', (done) ->
      @bbsMenu.fetch (error, res) =>
        expect(res.body.text.match /2chの入り口/m).to.be.exist
        done()

  describe '#getBbsUrl', ->
    it 'should return the BBS url', (done) ->
      @bbsMenu.update =>
        expect(@bbsMenu.getBbsUrl('CCさくら')).to.be.equal 'http://engawa.2ch.net/sakura/'
        done()
