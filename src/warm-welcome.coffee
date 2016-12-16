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

module.exports = (robot) ->
  robot.respond /hello/, (msg) ->
    msg.reply "hello!"

  robot.hear /orly/, ->
    msg.send "yarly"
