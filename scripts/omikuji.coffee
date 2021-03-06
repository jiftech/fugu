# Description:
#   omikiji 2017
#
# Commands:
#   fugu omikuji - happy omikuji
#
# Author:
#   jiftech

Slack = require 'hubot-slack-enhance'

foodList = [
  ":apple:", ":appleinc:", ":eggplant:", ":one: :mount_fuji: :two: :taka: :three: :eggplant:", ":meat_on_bone:", ":fried_shrimp:",
  ":ramen:", ":ramen: :tiger: :house:", ":nabe:", ":sushi:", ":sake:", ":fugu:", ":partyparrot:", ":rabbit:", ":tea:", ":weed:",
  ":fugu: :sushi:", ":fugu: :sake:", ":fugu: :nabe:"
]

wordList = [
  "進捗", "卒論", "わかめ", "抹茶", "華金", "Cygames", "Wantedly", "研究", "論文",
  "助け", "辛い", "pabot", "peter", "fugu"
]

module.exports = (robot) ->
  return unless Slack.isSlackAdapter robot
  slack = Slack.getInstance robot

  robot.respond /omikuji/i, (res) ->
    attach = slack.generateAttachment "danger",
      title: "Omikuji"

    fortune =
      title: "Fortune"
      value:  genFortune res
      short: false

    luckyFood =
      title: "Lucky Food"
      value:  res.random foodList
      short: true

    luckyWord =
      title: "Lucky Word"
      value:  res.random wordList
      short: true

    attach.fields = [fortune, luckyFood, luckyWord]

    console.log res.envelope.room
    slack.sendAttachment res.envelope.room, [attach]


fortuneList = [
  "大吉", "大吉", "大吉", # 15%
  "中吉", "中吉", "中吉", "中吉", # 20%
  "小吉", "小吉", # 10%
  "吉"  , "吉"  , "吉"  , "吉"  , # 20%
  "末吉", "末吉", # 10%
  "凶"  , "凶"  , "凶", # 15%
  "大凶", "大凶"  # 10%
]

genFortune = (res) ->
  fortune = res.random fortuneList
  emoji = getFortuneEmoji fortune, res
  ":#{emoji}: #{fortune} :#{emoji}:"

getFortuneEmoji = (fortune, res) ->
  switch fortune
    when "大吉" then res.random ["sun_with_face", "rainbow", "fastparrot"]
    when "中吉" then res.random ["sparkles", "sunny", "dealwithitparrot"]
    when "小吉" then res.random ["star", "mostly_sunny", "chillparrot"]
    when "吉"   then res.random ["o", "full_moon_with_face", "partyparrot"]
    when "末吉" then res.random ["no_mouth", "cloud", "parrotwave1"]
    when "凶"   then res.random ["innocent", "lightning", "boredparrot"]
    when "大凶" then res.random ["skull", "tornado", "explodyparrot"]
