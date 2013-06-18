helper = require '../../test_helper'

Thread = helper.require '2ch/thread'
Message = helper.require '2ch/message'
ThreadWatcher = helper.require '2ch/thread_watcher'

describe 'ThreadWatcher', ->
  beforeEach ->
    @subject = new ThreadWatcher
      bbsName:'CCさくら',
      query: /ドキドキはにゃん村/
      interval: 1000

  describe '#constructor', ->
    it 'should have interval at least 5000', ->
      expect(@subject.interval).to.be.at.least 5000

  describe '#destroy', ->
    it 'should stop watching', ->
      @subject.start()
      @subject.destroy()
      expect(@subject.isWatching()).to.be.false

    it 'should remove event listeners', ->
      @subject.undelegateEvents = sinon.stub()
      @subject.destroy()
      expect(@subject.undelegateEvents.called).to.be.true

  describe '#delegateEvents', ->
    beforeEach (done) ->
      @subject.update => done()

    it 'should listen a thread event', ->
      expect(@subject.thread.listeners 'update').to.have.length 1

  describe '#undelegateEvents', ->
    beforeEach (done) ->
      @subject.update =>
        @subject.undelegateEvents()
        done()

    it 'should remove a event listener from thread', ->
      expect(@subject.thread.listeners 'update').to.have.length 0

  describe '#start', ->
    it 'should start watching', ->
      @subject.start()
      expect(@subject.isWatching()).to.be.true

  describe '#stop', ->
    it 'should stop watching', ->
      @subject.start()
      @subject.stop()
      expect(@subject.isWatching()).to.be.false

  describe '#update', ->
    it 'should return the new messages', (done) ->
      @subject.update (error, messages) ->
        expect(messages).to.have.length 27
        expect(messages[0]).to.be.an.instanceof Message
        done()

  describe '#setThread', ->
    it 'should call delegate methods', ->
      @subject.undelegateEvents = sinon.stub()
      @subject.delegateEvents = sinon.stub()
      @subject.setThread new Thread('http://example.com/')
      expect(@subject.undelegateEvents.called).to.be.true
      expect(@subject.delegateEvents.called).to.be.true

  describe '#findNewThread', ->
    context 'found', ->
      it 'should return the new thread', (done) ->
        @subject.findNewThread (error, thread) ->
          expect(thread).to.be.an.instanceof Thread
          done()

    context 'not found', ->
      it 'should return null', (done) ->
        @subject.bbs.fetchThreadHeader = sinon.stub().callsArgWith 1, null, null
        @subject.findNewThread (error, thread) ->
          expect(thread).to.be.null
          done()

      it 'should emit miss event', (done) ->
        @subject.bbs.fetchThreadHeader = sinon.stub().callsArgWith 1, null, null
        @subject.on 'miss', -> done()
        @subject.findNewThread ->
