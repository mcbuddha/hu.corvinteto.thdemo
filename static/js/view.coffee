[API, _, VH] =
  [window._view = {},
  window._,
  window._view_helper]

# canvas width in pixels
API.a = null

canvas = null
context = null

resize = ->
  API.a = _.min [window.innerWidth, window.innerHeight]
  [canvas.width, canvas.height] = [API.a, API.a]
  ___ "resized canvas to #{API.a}x#{API.a}"

# set up the html5 canvas and callbacks
API.init = ->
  window.addEventListener 'resize', resize, no
  canvas = document.getElementById 'view-canvas'
  context = canvas.getContext '2d'
  resize()