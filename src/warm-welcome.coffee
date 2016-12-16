# Description
#   A hubot script for maintaining channel welcome messages
#
# Configuration:
#   none
#
# Commands:
#   hubot show|set|remove welcome message - <shows|sets|removes welcome message in current channel>
#   hubot show|set|remove welcome message --in channel <shows|sets|removes welcome message in specified>
#
# Notes:
#   message can be msg
#   --in room parameter optional unless DM
#
# Author:
#   parksjr[@parksjr]

# vars/settings
roomMessageKey =(roomName) ->
	"room-welcome-msg-#{roomName}"
cannotSetMessageErrorResponse = (robotName, message) ->
	robotName = robotName or "hubot"
	message = message or "Welcome to this channel, humans!"
	"What room do you want to set the welcome message in?\n`#{robotName} set welcome message to #{message} --in #general`"
successSetMessageResponse = (message, roomName) ->
	roomName = roomName or "this room"
	message = message or "undefined"
	"Successfully set welcome message in #{roomName} to `#{message}`"
successRemoveMessageResponse = (roomName) ->
	roomName = roomName or "this room"
	"Successfully removed the welcome message in #{roomName}"
noWelcomeMessageResponse = (robotName, room) ->
	robotName = robotName or "hubot"
	room = room or "this room"
	"No welcome messages for #{room}. Create one like this \n`#{robotName} set welcome message to Welcome to this channel, humans!`"
welcomeMessageResponse = (objMsg) ->
	"Welcome message for {objMsg.room}: ```#{objMsg.message}``` last updated by #{objMsg.user}"

# objects
newMessageObject = (room, message, user) ->
	{
		room: room or null,
		message: message or '',
		user: user or null
	}

# methods
getRoomMessage = (rBrain, room) ->
	curMessage = rBrain.get(roomMessageKey(room)) or newMessageObject()
	curMessage

setRoomMessage = (rBrain, objMsg) ->
	return unless objMsg?
	rBrain.set roomMessageKey(objMsg.room), objMsg

# robot stuff
module.exports = (robot) ->
  
	robot.enter (res) ->
		brain = robot.brain
		roomName = res.message.room
		curMessage = getRoomMessage brain, roomName
		joinUser = res.message.user.name
		res.reply curMessage.message unless (curMessage.message == '' || curMessage.room == null)
		
	
	robot.respond /set welcome (?:message|msg) to (.+?)(?: --in ([a-z0-9\-_]+))?$/i, (res) ->
		newMsg = res.match[1]
		inRoom = res.match[2] or null
		curRoom = res.message.room
		user = res.message.user.name
		robotName = res.robot.name
		# if room is DM and --in room is null
		if curRoom == user && !inRoom?
			# cannot set welcome message error response
			res.send cannotSetMessageErrorResponse robotName, newMsg
			return
		# if --in room is not null
		if inRoom?
			setRoomMessage robot.brain, newMessageObject(inRoom, newMsg, user)
			res.send successSetMessageResponse newMsg, inRoom
			return
		# if inRoom is null
		if !inRoom?
			setRoomMessage robot.brain, newMessageObject(curRoom, newMsg, user)
			res.send successSetMessageResponse newMsg
	
	robot.respond /show welcome (?:message|msg)(?: --in ([a-z0-9\-_]+))?$/i, (res) ->
		brain = robot.brain
		inRoom = res.match[1] or null
		curRoom = res.message.room
		curMessage = getRoomMessage brain, inRoom or curRoom
		robotName = res.robot.name
		if (curMessage.message == '' || curMessage.room == null)
			res.send noWelcomeMessageResponse(robotName, inRoom)
		else
			res.send welcomeMessageResponse curMessage
	
	robot.respond /remove welcome (message|msg)(?: --in ([a-z0-9\-_]+))?$/i, (res) ->
		inRoom = res.match[2] or null
		curRoom = res.message.room
		user = res.message.user.name
		if curRoom == user && !inRoom?
			res.send cannotSetMessageErrorResponse robotName, newMsg
			return
		if inRoom?
			setRoomMessage robor.brain, newMessageObject(inRoom, "", user)
			res.send successRemoveMessageResponse inRoom
			return
		if !inRoom?
			setRoomMessage robot.brain, newMessageObject(curRoom, "", user)
			res.send successRemoveMessageResponse curRoom
  
  robot.respond /test welcome msg/i, (res) ->
    res.send "testing"
