_ = require 'lodash'
{EventEmitter} = require 'events'

BbsMenu = require './bbs_menu'
Bbs = require './bbs'
Thread = require './thread'

class BbsMenuFactory
  @_bbsMenu: null

  get: ->
    @_bbsMenu = new BbsMenu() unless @_bbsMenu
    @_bbsMenu

bbsMenuFactory = new BbsMenuFactory()

module.exports = class ThreadWatcher extends EventEmitter
  constructor: (args) ->
    args = _.defaults args,
      interval:600000
      bbsMenu: null
    {@bbsName, @query, @interval, @bbsMenu} = args

    @interval = 5000 if @interval < 5000
    @bbsMenu = bbsMenuFactory.get() unless @bbsMenu?
    @bbs = new Bbs(@bbsMenu, @bbsName)
    @thread = null
    @_watching = false
    @_initializeEvents()

  _initializeEvents: ->
    @events =
      'thread error': (error) => @emit('error', error)
      'thread update': (messages) => @emit('update', messages)
      'thread reload': (title) => @emit('reload', title)
      'thread begin': (title) => @emit('begin', title)
      'thread end': (title) => @emit('end', title)
    @delegateEvents()

  delegateEvents: ->
    _.forEach @events, (fn, key) =>
      [propName, eventName] = key.split /\s+/
      @[propName]?.on eventName, fn

  undelegateEvents: ->
    _.forEach @events, (fn, key) =>
      [propName, eventName] = key.split /\s+/
      @[propName]?.off eventName, fn

  isWatching: ->
    @_watching

  start: ->
    return if @_watching
    @_watching = true
    @_run()

  _run: =>
    return unless @_watching
    @update =>
      setTimeout @_run, @interval

  stop: ->
    @_watching = false

  update: (done) ->
    if @thread? and not @thread.isEnded()
      @thread.update (error, messages) => done? null, messages
    else
      @findNewThread (error, thread) =>
        return done? error if error
        return done? null, [] unless thread?
        @setThread thread
        @thread.update (error, messages) => done? null, messages

  setThread: (thread) ->
    @undelegateEvents()
    @thread = thread
    @delegateEvents()

  findNewThread: (done) ->
    @bbs.fetchThreadHeader @query, (error, header) =>
      if error
        @emit 'error', error
        return done error
      else if not header
        @emit 'miss'
        return done null, null
      done null, new Thread(@bbs, header.number, header.title)
