[API, _, $, IO, VH, MAP] =
  [window._video = {},
  window._,
  window.$,
  window.io,
  window._view_helper,
  window._map]

API.SIO = ':4567' # socket.io port
sock = null # socket.io socket

player = null
now_playing = null

mkfilter = (d) ->
  brightness = Math.floor 100*d[0] - 50
  contrast = Math.floor 200*d[1]
  grayscale = Math.floor 100*d[2]
  "brightness(#{brightness}%) contrast(#{contrast}%) grayscale(#{grayscale}%)"

select = (i) ->
  ___ ['select', i]
  now_playing = i % MAP.length
  player.src = '/static/vid/'+MAP[now_playing][2]
  player.play()
  player.volume = 0

on_controls = (d) ->
  ___ ['controls', d]
  player.style.webkitFilter = mkfilter d

API.init = ->
  player = $('#player')[0]
  player.addEventListener 'ended', -> select now_playing+1

  sock = IO.connect API.SIO
  sock.on 'connect', ->
    ___ 'connected'
    sock.emit 'video'
  sock.on 'message', (d) -> ___ "got #{d}"

  sock.on 'select', (d) -> select MAP.indexOf _.find MAP, (m) -> m[0] is d
  sock.on 'controls', on_controls
  sock.on 'seek', (d) -> player.currentTime += (if d is 'left' then -10 else 10)
  sock.on 'speed', (d) -> player.playbackRate += (if d is 'slower' then -0.1 else 0.1)
  sock.on 'pause', (d) -> if player.paused then player.play() else player.pause()