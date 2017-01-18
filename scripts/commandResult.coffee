# Description:
#   post message about command result
#

Slack = require 'hubot-slack-enhance'
module.exports = (robot) ->
  return unless Slack.isSlackAdapter robot
  slack = Slack.getInstance robot

  robot.router.post '/slack/command-result/', (req, res) ->
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

    slack.sendAttachment res.envelope.room, [attach]
