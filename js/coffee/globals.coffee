#global object that will be the interface to the functions
FE = {}

#root is the global object
root = window or module?.exports or @

#make it global
root.FE = FE

#global debug flag
_DEBUG_ = true

#timout in ms for pseudo non blocking
MS_PSEUDO_NONBLOCKING = 0

_defaultCallback = (c) -> c

DEFAULT_WIDTH = 800
DEFAULT_HEIGHT = 600




