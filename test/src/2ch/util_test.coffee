helper = require '../../test_helper'

util = helper.require '2ch/util'

describe 'util', ->
  beforeEach ->
    @subject = util

  describe '#escapeRegExpChars', (str) ->
    it 'should escape RegExp characters', ->
      expect(@subject.escapeRegExpChars '.?*+^$[]\\(){}|-').to.be.equal '\\.\\?\\*\\+\\^\\$\\[\\]\\\\\\(\\)\\{\\}\\|\\-'
