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
  resize: ['resize']
  keydown: ['keydown']
  keyup: ['keyup']
API.get_x = (e, i=0) -> e.targetTouches?[i].pageX or e.offsetX
API.get_y = (e, i=0) -> e.targetTouches?[i].pageY or e.offsetY
API.getxy = (e) -> [(API.get_x e), (API.get_y e)]
API.add_event_listener = (el, event_key, fun, prevent=on) ->
  el.addEventListener event, ((e) ->
    fun e
    e.preventDefault() if prevent), no for event in API.events[event_key]

API.ndc = (c,i) -> [c[0]/i[0], c[1]/i[1]]
API.frame = null
raf = null
API.f = -> raf = webkitRequestAnimationFrame API.frame
API.c = -> webkitCancelAnimationFrame raf if raf
API.F = -> API.c(); API.f()
API.n = performance.webkitNow()

API.GAMMA = (alpha,beta) -> Math.floor alpha / beta # snap to grid
API.EPSILON = API.add_event_listener