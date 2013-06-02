helper = require '../../test_helper'

BbsMenu = helper.require '2ch/bbs_menu'
Bbs = helper.require '2ch/bbs'

describe 'Bbs', ->
  beforeEach (done) ->
    @bbsMenu = new BbsMenu()
    @bbsMenu.update =>
      @subject = new Bbs(@bbsMenu, 'CCさくら')
      done()

  describe '#fetch', ->
    it 'should fetch subject.txt which is decoded from cp932', (done) ->
      @subject.fetch (error, res) ->
        expect(res.body.text.match /ドキドキはにゃん村/).to.be.exist
        done()

  describe '#fetchThreadHeader', ->
    it 'should return the thread header', (done) ->
      @subject.fetchThreadHeader 'ドキドキはにゃん村', (error, threadHeader) ->
        expect(threadHeader).to.be.eql
          title: 'ドキドキはにゃん村'
          number: 1231808850
          count: 27
        done()

    it 'should accept using RegExp query', (done) ->
      @subject.fetchThreadHeader /さくらちゃんの幸せを願うスレpart[0-9]+/im, (error, threadHeader) ->
        expect(threadHeader).to.be.eql
          number: 1337968043
          title: 'さくらちゃんの幸せを願うスレpart1'
          count: 12
        done()

    it 'should return the thread header which has more messages than others', (done) ->
      @subject.fetchThreadHeader /今週のさくらちゃん/, (error, threadHeader) ->
        expect(threadHeader).to.be.eql
          title: '【はにゃん】今週のさくらちゃんPart21【ですわ〜】'
          number: 1210326553
          count: 382
        done()
