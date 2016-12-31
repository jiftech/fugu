# Description:
#   omikiji 2017
#
# Commands:
#   fugu omikuji - happy omikuji
#
# Author:
#   jiftech

Slack = require 'hubot-slack-enhance'

newyearList = [
  "chicken", "rooster", "bamboo", "congratulations", "sunrise"
]

foodList = [
  ":apple:", ":appleinc:", ":eggplant:", ":one: :mount_fuji: :two: :taka: :three: :eggplant:", ":meat_on_bone:", ":fried_shrimp:",
  ":ramen:", ":ramen: :tiger: :house:", ":nabe:", ":sushi:", ":sake:", ":fugu:", ":partyparrot:", ":rabbit:", ":tea:", ":weed:",
  ":fugu: :sushi:", ":fugu: :sake:", ":fugu: :nabe:"
]

wordList = [
  "baka", "hoge", "進捗", "卒論", "わかめ", "wakame", "抹茶", "華金", "金曜日", "Cygames", "Wantedly", "研究", "論文",
  "fugu", "joke", "random", "助け", "辛い", "今日", "afo", "parrot"
]

module.exports = (robot) ->
  # return unless Slack.isSlackAdapter robot
  slack = new Slack robot

  robot.respond /omikuji/i, (res) ->
    newyear = res.random newyearList

    attach = slack.generateAttachment 'danger',
      fallback: "omikuji"
      pretext: ":#{newyear}: Happy New Year 2017 :#{newyear}:"
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
