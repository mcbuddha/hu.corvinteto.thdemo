[API, _, IO] =
  [exports._app = {},
  (require 'lodash'),
  (require 'socket.io')]
___ = (x)->console.log x

control_socket = null
video_socket = null

on_select = (d) ->
  ___ "select #{d}"
  video_socket?.emit 'select', d

on_controls = (d) ->
  ___ "controls #{d}"
  video_socket?.emit 'controls', d

on_seek = (d) ->
  ___ "seek #{d}"
  video_socket?.emit 'seek', d

on_speed = (d) ->
  ___ "speed #{d}"
  video_socket?.emit 'speed', d

on_pause = ->
  ___ 'pause'
  video_socket?.emit 'pause'

API.SIO = (parseInt process.argv[2]) or 4567
IO = IO.listen API.SIO, 'log level': 1
IO.sockets.on 'connection', (s) ->
  ___ "connected #{s.id}"
  s.on 'message', (d) -> ___ "got #{d}"

  s.on 'control', -> control_socket = s
  s.on 'video', -> video_socket = s

  s.on 'select', on_select
  s.on 'controls', on_controls

  s.on 'seek', on_seek
  s.on 'speed', on_speed
  s.on 'pause', on_pause

___ "socket.io listening on #{API.SIO}"