helper = require '../../test_helper'

BbsMenu = helper.require '2ch/bbs_menu'
Bbs = helper.require '2ch/bbs'
Thread = helper.require '2ch/thread'
Message = helper.require '2ch/message'
util = helper.require '2ch/util'

describe 'Thread', ->
  beforeEach (done) ->
    @bbsMenu = new BbsMenu()
    @bbsMenu.update =>
      bbs = new Bbs(@bbsMenu, 'CCさくら')
      @subject = new Thread(bbs, 1231808850, 'ドキドキはにゃん村')
      done()

  describe '#toString', ->
    beforeEach (done) ->
      @subject.update -> done()

    it 'should return the raw thread data', ->
      expectedDate = util.convertToUtf8 helper.getFixture('1231808850.dat')
      expect(@subject.toString()).to.be.equal expectedDate

  describe '#fetch', ->
    it 'should fetch the thread data which is decoded from cp932', (done) ->
      @subject.fetch (error, res) ->
        expect(res.body.text.match /政府ははにゃん規制を検討/).to.be.exist
        done()

  describe '#update', ->
    context 'on success', ->
      it 'should update the messages', (done) ->
        @subject.update =>
          expect(@subject.messages).to.have.length 27
          expect(@subject.messages[0]).to.be.an.instanceof Message
          done()

      it 'should emit begin event on first update', (done) ->
        stub = sinon.stub()
        @subject.on 'begin', stub
        @subject.update =>
          @subject.update =>
            expect(stub.calledOnce).to.be.true
            expect(stub.calledWith 'ドキドキはにゃん村').to.be.true
            done()

      it 'should emit update event', (done) ->
        @subject.on 'update', (newMessages) ->
          expect(newMessages).to.have.length 27
          done()
        @subject.update()

      it 'should update the messages newly every time', (done) ->
        @subject.update =>
          expect(@subject.messages).to.have.length 27
          @subject.update (error, newMessages) =>
            expect(@subject.messages).to.have.length 31
            expect(newMessages).to.have.length 4
            done()

    context 'on moved', ->
      it 'should emit end event', (done) ->
        @subject.fetch = sinon.stub().callsArgWith 0, null, status: 302
        @subject.on 'end', (title) ->
          expect(title).to.be.equal 'ドキドキはにゃん村'
          done()
        @subject.update()

    context 'on error', ->
      it 'should emit error event', (done) ->
        @subject.fetch = sinon.stub().callsArgWith 0, null, status: 500
        @subject.on 'error', (error) ->
          expect(error).to.be.an.instanceof Error
          done()
        @subject.update()
