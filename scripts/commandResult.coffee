# Description:
#   post message about command result
#

Slack = require 'hubot-slack-enhance'
HUBOT_SLACK_NOTIFICATION_ROOM = process.env.HUBOT_SLACK_NOTIFICATION_ROOM
module.exports = (robot) ->
  return unless Slack.isSlackAdapter robot
  slack = Slack.getInstance robot

  robot.router.post '/hubot/slack/command-result/', (req, res) ->
    unless HUBOT_SLACK_NOTIFICATION_ROOM?
      rebot.logger.warning "Please specify \"HUBOT_SLACK_NOTIFICATION_ROOM\" environment!"
      return

    comres = req.body

    if comres.result == "OK"
      title = slack.emojideco "Command Succeeded", "partyparrot"
      color = "good"
    else if comres.result == "NG"
      title = slack.emojideco "Command Failed", "explodyparrot"
      color = "danger"

    attach = slack.generateAttachment color,
      title: title
      pretext: comres.replyTo
      mrkdwn_in: ["fields"]
      fields: [
        title: "command"
        value: "`#{comres.command}`"
        short: false
      ,
        title: "directory"
        value: "`#{comres.directory}`"
        short: false
      ,
        title: "hostname"
        value: comres.hostname
        short: true
      ,
        title: "user"
        value: comres.user
        short: true
      ,
        title: "executed at"
        value: comres.executedAt
        short: true
      ,
        title: "elapsed time"
        value: comres.elapsedTime
        short: true
      ]

    slack.sendAttachment HUBOT_SLACK_NOTIFICATION_ROOM, [attach]
    res.send "OK"
