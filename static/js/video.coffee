[API, _, $, IO, VH] =
  [window._video = {},
  window._,
  window.$,
  window.io,
  window._view_helper]

API.SIO = ':4567' # socket.io port
sock = null # socket.io socket

SRC = (d) -> "/static/vid/source-#{d}.webm"
sources = _.collect ['a','b','c','d'], SRC
player = null
now_playing = null

mkfilter = (d) ->
  brightness = Math.floor 100*d[0] - 50
  contrast = Math.floor 200*d[1]
  grayscale = Math.floor 100*d[2]
  "brightness(#{brightness}%) contrast(#{contrast}%) grayscale(#{grayscale}%)"

select = (i) ->
  ___ ['select', i]
  now_playing = i % sources.length
  player.src = sources[now_playing]
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

  sock.on 'select', (d) -> select sources.indexOf SRC d
  sock.on 'controls', on_controls