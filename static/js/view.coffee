[API, _, $, IO, VH] =
  [window._view = {},
  window._,
  window.$,
  window.io,
  window._view_helper]

API.SIO = ':4567' # socket.io port
API.d = null # window dimension

API.so = sock = null # socket.io socket
canvas = null # html5 canvas element
context = null # canvas context

resize = ->
  API.d = [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = API.d
  ___ "resized to #{API.d}"

API.init = ->
  window.addEventListener 'resize', resize, no

  canvas = document.getElementById 'view-canvas'
  context = canvas.getContext '2d'

  API.so = sock = IO.connect API.SIO
  sock.on 'connect', ->
    ___ 'connected'
  sock.on 'message', (d) -> ___ "got #{d}"

  resize()
