helper = require '../../test_helper'
moment = require 'moment'

Message = helper.require '2ch/message'

describe 'Message', ->
  before ->
    @clock = sinon.useFakeTimers()

  after ->
    @clock.restore()

  context 'normal message', ->
    beforeEach ->
      @subject = new Message('CC名無したん<>sage<>2009/01/13(火) 10:10:15 ID:I/hA9Kq50<> はにゃ～ん大戦争にゃん&hearts;<br>なんちゃって&#9830; <>', 100)

    describe '#isOver1000Message', ->
      it 'should return false', ->
        expect(@subject.isOver1000Message()).to.be.false

    describe '#isAboneMessage', ->
      it 'should return true', ->
        expect(@subject.isAboneMessage()).to.be.false

    describe '#constructor', ->
      it 'should have the index property', ->
        expect(@subject.number).to.be.equal 100

      it 'should have the name property', ->
        expect(@subject.name).to.be.equal 'CC名無したん'

      it 'should have the mail property', ->
        expect(@subject.mail).to.be.equal 'sage'

      it 'should have the postedAt property', ->
        expect(@subject.postedAt.isSame('2009-01-13 10:10:15')).to.be.true

      it 'should have the tripId property', ->
        expect(@subject.tripId).to.be.equal 'I/hA9Kq50'

      it 'should have the body property', ->
        expect(@subject.body).to.be.equal 'はにゃ～ん大戦争にゃん&hearts;<br>なんちゃって&#9830;'

  context 'over 1000 thread message', ->
    beforeEach ->
      @subject = new Message('１００１<><>Over 1000 Thread<> このスレッドは１０００を超えました。 <br> もう書けないので、新しいスレッドを立ててくださいです。。。  <>', 1001)

    describe '#isOver1000Message', ->
      it 'should return true', ->
        expect(@subject.isOver1000Message()).to.be.true

    describe '#isAboneMessage', ->
      it 'should return false', ->
        expect(@subject.isAboneMessage()).to.be.false

    describe '#constructor', ->
      it 'should have the index property', ->
        expect(@subject.number).to.be.equal 1001

      it 'should have the name property', ->
        expect(@subject.name).to.be.equal '１００１'

      it 'should have the mail property', ->
        expect(@subject.mail).to.be.equal ''

      it 'should have the postedAt property', ->
        expect(@subject.postedAt.isSame(moment())).to.be.true

      it 'should have the tripId property', ->
        expect(@subject.tripId).to.be.equal ''

      it 'should have the body property', ->
        expect(@subject.body).to.be.equal 'このスレッドは１０００を超えました。 <br> もう書けないので、新しいスレッドを立ててくださいです。。。'

  context 'aboned message', ->
    beforeEach ->
      @subject = new Message('あぼーん<>あぼーん<>あぼーん<>あぼーん<>あぼーん', 100)

    describe '#isOver1000Message', ->
      it 'should return false', ->
        expect(@subject.isOver1000Message()).to.be.false

    describe '#isAboneMessage', ->
      it 'should return true', ->
        expect(@subject.isAboneMessage()).to.be.true

    describe '#constructor', ->
      it 'should have the index property', ->
        expect(@subject.number).to.be.equal 100

      it 'should have the name property', ->
        expect(@subject.name).to.be.equal 'あぼーん'

      it 'should have the mail property', ->
        expect(@subject.mail).to.be.equal 'あぼーん'

      it 'should have the postedAt property', ->
        expect(@subject.postedAt.isSame(moment())).to.be.true

      it 'should have the tripId property', ->
        expect(@subject.tripId).to.be.equal ''

      it 'should have the body property', ->
        expect(@subject.body).to.be.equal 'あぼーん'
