window.___ = (x) -> console.log x
[API, _] =
  [window._view_helper = {},
  window._]

# clear context
API.clr = (ctx, w, h=w) -> ctx.clearRect 0, 0, w, h

# easy event handling
API.events =
  down: ['mousedown', 'touchstart']
  up: ['mouseup', 'touchend']
  move: ['mousemove', 'touchmove']
API.get_x = (e, i=0) -> e.offsetX
API.get_y = (e, i=0) -> e.offsetY
API.add_event_listener = (el, event_key, fun) ->
  el.addEventListener event, ((e) ->
    fun e
    e.preventDefault()), no for event in API.events[event_key]
