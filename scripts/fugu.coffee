# Description:
#   fugu commands.
#
# Commands:
#   fugu hoge - respond to hoge
#
# Author:
#   jiftech

module.exports = (robot) ->
  hogeList = ['hoge', 'fuga', 'piyo', 'foo', 'bar', 'baz', 'afo', 'baka', 'fugu']

  robot.hear /hoge/i, (res) ->
    res.send res.random hogeList
