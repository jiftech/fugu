# Description:
#   check prime number.
# Commands:
#   primecheck <num> - check whether num is prime.
#
# Author:
#   jiftech

# ガバガバアルゴリズム
primeCheck = (numStr) ->
  num = parseInt numStr
  return false if num is 1
  return true if num is 2
  return false if num % 2 is 0

  sqrt = Math.sqrt num
  odds = (x for x in [3..sqrt] by 2)

  for odd in odds
    return false if num % odd is 0

  true

module.exports = (robot) ->
  robot.hear /primecheck\s*([1-9]\d{0,11})/i, (res) ->
    num = res.match[1]
    if primeCheck num
      res.send "#{num} is prime!!!!!"
    else
      res.send "#{num} is not prime..."

  # robot.hear /([1-9]\d{2,9})/g, (res) ->
  #   rgxPc = /primecheck/i
  #   return if rgxPc.test res.message.text
  #   for num in res.match
  #     res.send(msgPrime num) if primeCheck num
