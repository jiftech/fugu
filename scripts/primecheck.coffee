# Description:
#   check whether number(3-10 digits) in conversation is prime.
#   you can also check prime manually with "primecheck <num>".
# Commands:
#   primecheck <num> - check whether num is prime.
#
# Author:
#   jiftech

msgPrime = (num) ->
  "#{num} is prime!!!!!"

msgNotPrime = (num) ->
  "#{num} is not prime..."

# ガバガバアルゴリズム
primeCheck = (numStr) ->
  num = Number.parseInt numStr
  return false if (num % 2 is 0) or (num is 1)

  sqrt = Math.sqrt num
  odds = (x for x in [3..sqrt] by 2)

  for odd in odds
    return false if num % odd is 0

  true

module.exports = (robot) ->
  robot.hear /primecheck\s*([1-9]\d{0,10})/i, (res) ->
    num = res.match[1]
    if primeCheck num
      res.send(msgPrime num)
    else
      res.send(msgNotPrime num)

  robot.hear /([1-9]\d{2,9})/g, (res) ->
    rgxPc = /primecheck/i
    return if rgxPc.test res.message.text
    for num in res.match
      res.send(msgPrime num) if primeCheck num
