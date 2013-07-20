#a simple debugger function
#controlled by the global _DEBUG_ flag
dlog = (msg) -> 
  console?.log(msg) if _DEBUG_

#throws an error if globals _DEBUG_ flag is set to true
derror = (msg, error_name="Debug Error") -> 
  throw new Error(error_name+': '+msg) if _DEBUG_

#call back required
cbr = (cb,function_name) -> 
  until cb then throw new Error('Callback required for '+function_name)

#save isFunction check
isFunction = (functionToCheck) ->
  getType = {}
  return functionToCheck and getType.toString.apply(functionToCheck) is '[object Function]'

#nonblocker helper
#this method might be extended in future to provide real non blocking (i.e. worker) function handling
nb = (cb, p...) ->
  if cb and isFunction(cb)
    root.setTimeout(cb, MS_PSEUDO_NONBLOCKING, p...)
  
  return p[0] if p.length is 1
  return p 

#first function first
#interpretes the firt function of an parameter array as a callback
#fff = (params,defaults...) ->
#  dlog('call to fff')
#  dlog(params)
#  dlog(defaults)
#  first_func = null
#  p2 = []
#  i = 0
#  for par in params
#    do (par) ->
#      if isFunction(par) and not first_func
#        first_func = par
#      else
#        p2.push(par)
#
#  #give the parameters default values
#  for d, i in defaults
#    do (d) ->
#      p2[i] ?= d
#
#  if not first_func
#    # we return a dummy callback
#    first_func = _defaultCallback
#    #derror('No Callback Warning', 'callback is expected for fff')
#  p2.unshift(first_func)
#
#  return p2

lff = (params,defaults...) ->
  dlog('call to lff')
  dlog(params)
  dlog(defaults)
  last_func = null
  p2 = []
  i = 0
  #for par in params
  #  do (par, i) ->
  #    dlog(i)
  #    if isFunction(par) and not first_func
  #      first_func = par
  #    else
  #      p2.push(par)
  #debugger
  i = params.length - 1
  while i >= 0
    console.log('hiho'+i)
    #debugger;
    par = params[i]
    if isFunction(par) and not last_func
      last_func = par
    else
      p2.unshift(par)
    i = i - 1
  #dlog(p2)
  #debugger

  #give the parameters default values
  for d, i in defaults
    do (d) ->
      p2[i] ?= d

  if not last_func
    # we return a dummy callback
    last_func = _defaultCallback
    #derror('No Callback Warning', 'callback is expected for fff')
  p2.unshift(last_func)

  return p2
console.log('lff now')
console.log(lff([0,1,2,3,4,5,(()->),6]))
console.log('lff now 2')

#optionalParameterDefaults 
#gives optional parameters a default value
opd = (params, defaults...) ->
  r = []

  for par, i in params
    do (par, i) ->
      r[i] = p ? defaults?[i]

  return r
