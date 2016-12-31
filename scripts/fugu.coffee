# Description:
#   fugu commands.
#
# Commands:
#   hoge - respond to hoge
#   hoge <num> - respond to hoge <num> times
#   fugu - eat fugu in various ways(and sometimes die)
#   fugu image - reply with fugu's image(using Google Custom Seacrch API, 100req/day)
#   :fugu: :sushi: - eat fugu's sushi
#   :fugu: :nabe: - eat fugu nabe
#   :fugu: :sake: - drink hire-zake
#   ゆく年 - くる年
#
# Author:
#   jiftech

hogeList = ['hoge', 'fuga', 'piyo', 'poyo', 'po', 'foo', 'bar', 'baz', 'afo', 'baka', 'fugu']
fuguList = [':sushi:', ':nabe:', ':sake:']
yumList  = ['yummy!', '美味しい!', '旨い!', 'ウンメェ〜']

module.exports = (robot) ->
  robot.hear /^hoge$/i, (res) ->
    res.reply res.random hogeList

  robot.hear /^hoge\s*([1-9]\d*)$/, (res) ->
    cnt = Math.min res.match[1], 20
    hoges = []
    for i in [1..cnt]
      hoges.push res.random hogeList
    res.reply hoges.join " "

  robot.hear /^fugu$/i, (res) ->
    food = ":fugu: #{res.random fuguList}"
    eat = msgWithEmoji food, "fork_and_knife"
    tet = tetrodotoxin res
    res.send "#{eat}\n#{tet}"

  robot.hear /:fugu:\s*(:sushi:|:nabe:|:stew:|:sake:)/i, (res) ->
    res.send tetrodotoxin res

  robot.respond /image/i, (res) ->
    fuguImage res, (url) ->
      res.reply url

  robot.hear /^ゆく年$/, (res) ->
    res.send "くる年"

msgWithEmoji = (msg, emoji) ->
  ":#{emoji}:  #{msg}  :#{emoji}:"

tetrodotoxin = (res) ->
  if Math.random() < 0.80
    msgWithEmoji res.random(yumList), "yum"
  else
    msgWithEmoji "YOU ARE DEAD", "skull_and_crossbones"

fuguImage = (res, cb) ->
  googleCseId = process.env.HUBOT_GOOGLE_CSE_ID
  if googleCseId
    # Using Google Custom Search API
    googleApiKey = process.env.HUBOT_GOOGLE_CSE_KEY
    if !googleApiKey
      res.robot.logger.error "Missing environment variable HUBOT_GOOGLE_CSE_KEY"
      res.send "Missing server environment variable HUBOT_GOOGLE_CSE_KEY."
      return
    q =
      q: "ふぐ",
      searchType:'image',
      safe: process.env.HUBOT_GOOGLE_SAFE_SEARCH || 'high',
      fields:'items(link)',
      cx: googleCseId,
      key: googleApiKey
    url = 'https://www.googleapis.com/customsearch/v1'
    res.http(url)
      .query(q)
      .get() (err, httpRes, body) ->
        if err
          if httpRes.statusCode is 403
            res.send "Daily image quota exceeded..."
          else
            res.send "Encountered an error :( #{err}"
          return
        if httpRes.statusCode isnt 200
          res.send "Bad HTTP response :( #{httpRes.statusCode}"
          return
        response = JSON.parse(body)
        if response?.items
          image = res.random response.items
          cb ensureImageExtension(image.link)
        else
          res.send "Oops. I had trouble searching '#{query}'. Try later."
          ((error) ->
            res.robot.logger.error error.message
            res.robot.logger
              .error "(see #{error.extendedHelp})" if error.extendedHelp
          ) error for error in response.error.errors if response.error?.errors
  else
    res.send "Google Image Search API is not longer available. " +
      "Please [setup up Custom Search Engine API](https://github.com/hubot-scripts/hubot-google-images#cse-setup-details)."

# Forces the URL look like an image URL by adding `#.png`
ensureImageExtension = (url) ->
  if /(png|jpe?g|gif)$/i.test(url)
    url
  else
    "#{url}#.png"
