Helper = require('hubot-test-helper')
helper = new Helper('../src/warm-welcome.coffee')
expect = require('chai').expect

# todo: build proper tests
describe 'warm-welcome', ->
  room = null
  beforeEach ->
    room = helper.createRoom(httpd: false)
    room.robot.brain.set "room-welcome-msg-room1", {room: "room1", message: "poop", user: "turd"}

  context 'test welcome message', ->
    beforeEach ->
      room.user.enter 'bob'

    it 'should respond', ->
      expect(room.messages).to.eql [
      ]
      