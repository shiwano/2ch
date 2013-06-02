helper = require '../../test_helper'
moment = require 'moment'

Message = helper.require '2ch/message'

describe 'Message', ->
  beforeEach ->
    @subject = new Message('CC名無したん<>sage<>2009/01/13(火) 10:10:15 ID:I/hA9Kq50<> はにゃ～ん大戦争にゃん&hearts;<br>なんちゃって&#9830; <>', 100)

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
