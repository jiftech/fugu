# Description:
#   fugu commands.
#
# Commands:
#   hoge - respond to hoge
#   fugu - eat fugu in various ways(and sometimes die)
#   :fugu: :sushi: - eat fugu's sushi
#   :fugu: :nabe: - eat fugu nabe
#   :fugu: :sake: - drink hire-zake
#
# Author:
#   jiftech

hogeList = ['hoge', 'fuga', 'piyo', 'foo', 'bar', 'baz', 'afo', 'baka', 'fugu']
fuguList = [':sushi:', ':nabe:', ':sake:']
yumList  = ['yummy!', '美味しい!', '旨い!', 'ウンメェ〜']

msgWithEmoji = (msg, emoji) ->
  ":#{emoji}:  #{msg}  :#{emoji}:"

module.exports = (robot) ->

  tetrodotoxin = (res) ->
    if Math.random() < 0.90
      msgWithEmoji res.random(yumList), "yum"
    else
      msgWithEmoji "YOU ARE DEAD", "skull_and_crossbones"

  robot.hear /^hoge$/i, (res) ->
    res.send res.random hogeList

  robot.hear /^fugu$/i, (res) ->
    food = ":fugu: #{res.random fuguList}"
    eat = msgWithEmoji food, "fork_and_knife"
    tet = tetrodotoxin res
    res.send "#{eat}\n#{tet}"

  robot.hear /:fugu:\s*(:sushi:|:nabe:|:stew:|:sake:)/i, (res) ->
    res.send tetrodotoxin res
