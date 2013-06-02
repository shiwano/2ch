helper = require '../test_helper'

subject = helper.require '2ch'

describe '2ch', ->
  it 'should export the library functions', ->
    expect(subject.BbsMenu).to.be.exist
    expect(subject.Bbs).to.be.exist
    expect(subject.Thread).to.be.exist
    expect(subject.ThreadWatcher).to.be.exist
