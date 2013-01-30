[API, _, $, IO, VH] =
  [window._view = {},
  window._,
  window.$,
  window.io,
  window._view_helper]

API.SIO = ':4567' # socket.io port
API.d = null # window dimension

sock = null # socket.io socket
controls_canvas = null # html5 canvas element
controls_context = null # canvas context
controls_d = null

controls_values = [.5, .5, .5]
update_controls = (e) ->
  return if e.type isnt 'touchmove'
  # normalized coordinates
  nx = (VH.get_x e)/e.target.width
  ny = 1-(VH.get_y e)/e.target.height

  if nx > 0 and ny > 0
    # update value
    control_index = Math.floor nx*controls_values.length % controls_values.length
    controls_values[control_index] = ny

    # update canvas
    VH.clr controls_context, controls_d[0], controls_d[1]
    controls_context.fillStyle = 'rgb(255,255,255)'
    dw = controls_d[0]/controls_values.length # bar width
    _.each controls_values, (c,i) ->
      x0 = i*dw
      y0 = controls_d[1]*(1-controls_values[i])
      hi = controls_d[1]*controls_values[i]
      controls_context.fillRect x0, y0, dw, hi

    # update socket
    sock?.emit 'controls', controls_values

on_select = (e) -> sock?.emit 'select', e.target.id[-1..-1]

resize = ->
  API.d = [window.innerWidth, window.innerHeight]

  $('#sources').width API.d[1]

  controls_d = [0.95*(API.d[0]-API.d[1]), API.d[1]]
  [controls_canvas.width, controls_canvas.height] = controls_d
  $('#controls').width controls_d[0]
  ___ "resized to #{API.d}"

API.init = ->
  window.addEventListener 'resize', resize, no

  _.each $('#sources > *'), (source) ->
    VH.add_event_listener source, 'down', on_select

  controls_canvas = $('#controls')[0]
  controls_context = controls_canvas.getContext '2d'

  #VH.add_event_listener controls_canvas, 'down', update_controls
  VH.add_event_listener controls_canvas, 'move', update_controls

  sock = IO.connect API.SIO
  sock.on 'connect', ->
    ___ 'connected'
    sock.emit 'control'
  sock.on 'message', (d) -> ___ "got #{d}"

  resize()
