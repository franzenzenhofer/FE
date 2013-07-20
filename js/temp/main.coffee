# /*! franze - v0.0.1 - last build: 2013-07-20 22:15:50 */
#global object that will be the interface to the functions
FE = {}

#root is the global object
root = window or module?.exports or @

#make it global
root.FE = FE

#global debug flag
_DEBUG_ = false

#timout in ms for pseudo non blocking
MS_PSEUDO_NONBLOCKING = 0

_defaultCallback = (c) -> c

DEFAULT_WIDTH = 800
DEFAULT_HEIGHT = 600





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
    #console.log('hiho'+i)
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
#console.log('lff now')
#console.log(lff([0,1,2,3,4,5,(()->),6]))
#console.log('lff now 2')

#optionalParameterDefaults 
#gives optional parameters a default value
opd = (params, defaults...) ->
  r = []

  for par, i in params
    do (par, i) ->
      r[i] = p ? defaults?[i]

  return r

#sets a min and max range for a given number
#mostly used for rgb values 
#as clamp will be used a lot in loops it is also available as loopupoptimized fe_clamp
#FE.clamp(number v, number min, number max)
#returns a value between min and max
FE.clamp = fe_clamp = 
  (v, min=0, max=255) -> Math.min(max, Math.max(min, v))

#makes any value positive
FE.pos = fe_pos = (v) ->
    if v<0 then v*-1 else v

#setting up a canvas envirement of an existing canvas
#returns [Canvas, CanvasContext, ImageData, CanvasPixelArray]
#FE.getCanvasToolbox(canvas)
#FE.getCanvasToolbox(canvas, callback)
FE.getCanvasToolbox = (c,cb) ->
  ctx = c.getContext('2d')
  dlog(ctx)
  dlog(c)
  dlog(c.width)
  dlog(c.height)
  #we need this later for ther pixel effect
  #ctx.webkitImageSmoothingEnabled = false;
  img_data = ctx.getImageData(0,0,c.width,c.height)

  img_data_data = img_data.data

  nb(cb, [c, ctx, img_data, img_data_data])


#takes either width or height as parameters - or - an object with a width and height
#FE.make(int width = 800, int height = 600, string origin, callback)
#returns a canvas
#i.e.:
#FE.make(400,300)
#FE.make(400, 300, callback)
#FE.make({width:400, height:300})
#FE.make({width:400, height:300}, callback)
#FE.make(canvas) #or any other element with a width and height
FE.make = (p...) ->

  [cb, object_or_width, height, origin]= a = lff(p,DEFAULT_WIDTH,DEFAULT_HEIGHT)
  dlog('in make')
  dlog(a)

  #[object_or_width, height, origin]=opd(p,DEFAULT_WIDTH,DEFAULT_HEIGHT)
  
  #if something like this FE.make({width:200, height:300})
  #or this FE.make(canvas)
  #was called
  if object_or_width.width and object_or_width.height
    element = object_or_width
    width = element.width
    height = element.height
    origin = (element?.getAttribute?('id') or element?.getAttribute?('data-origin'))
  else
    width = object_or_width

  c = root.document.createElement('canvas')
  c.width = width
  c.height = height
  c.setAttribute('origin', origin) if origin
  dlog(c)

  nb(cb,c)

#creates a new canvas envirement
FE.newCanvasToolbox = (p...) ->
  [cb, width, height, origin] = lff(p)

  #[width, height, origin] = opd(p)
  FE.getCanvasToolbox(FE.make(width, height, origin),cb)

#creates a new blank canvas envirement via an existing canvas
FE.newCanvasToolboxByCanvas = (c,cb) ->
  FE.getCanvasToolbox(FE.make(c.width, c.height, FE.origin(c)),cb)

#copys the visible state of one canvas to an existing or new canvas
#FE.copy(canvas, canvas, callback)
#i.e.:
#FE.copy(canvas)
#FE.copy(canvas, callback)
#FE.copy(canvas, other_canvas, callback)
#returns a new canvas or existing other_canvas
FE.copy = (c,p...) ->

  [cb, c2] = lff(p)
  #[c2] = opd(p)
  
  if c2 
    [c2, c2_ctx] = FE.getCanvasToolbox(c)
  else
    [c2, c2_ctx] = FE.newCanvasToolbox(c)
  dlog('hiho')
  c2_ctx.drawImage(c,0,0,c.width,c.height)
  dlog('cb of copy')
  dlog(cb)
  nb(cb,c2)

#create a canvas from an image
#needs a callback, in case the image is not yet loaded
#to be on the save side, it's best to always use this with a callback
#i.e.:
#FE.byImage(image, callback)
#FE.byImage(image) #unsafe, might throw an error
#returns a new canvas
FE.byImage =  (img, cb) ->
  #checks if the image is loaded (if it has a width and a hight)
  #TODO: check if there is another loadedstate property
  if img.width and img.height
    dlog('loaded')
    FE.copy(img, cb)
  else
    #throws an error, if the image is not loaded yet
    cbr(cb, 'FE.byImage (only if the image is not "loaded")')
    if isFunction(cb)
      #TODO: this method of assigning an event handler allowes only one event handler
      #per event, find a better method of assignings events (jquer add event handler like)
      img.onload = ()->FE.byImage(img,cb)
    return true

#TODO
#FE.byVideo(video, time, callback)

#createa a canvas from an array of r,g,b,a values and width and height
#i.e.:
#FE.byArray(array, width, height, callback)
#FE.byArray(array, widht, height)
#returns a new canvas
FE.byArray = (a, w, h, cb) ->
  #[cb,a,w,h] = fff(p)
  [c, ctx, imgd, pxs] = FE.newCanvasToolbox(w,h)
  i = 0
  for v,i in pxs
    do(v,i) ->
      pxs[i] = a[i]
  ctx.putImageData(imgd,0,0)
  nb(cb,c)

#gets a canvas, returns an image
#i.e.:
#FE.toImage(canvas, mimt_type, callback)
#FE.toImage(canvas, mimt_type)
#FE.toImage(canvas, callback)
#FE.toImage(canvas)
#returns an image, default a PNG
FE.toImage = (p...) ->
  [cb, c, mime]=lff(p, (FE.make()),'image/png')
  #[mime]=opd(p, 'image/png')
  img = new Image()
  img.src=c.toDataURL(mime, "")
  nb(cb,img)

#gets a canvas, returns an array
#i.e.::
#FE.toArray(canvas, callback)
#FE.toArray(canvas)
FE.toArray = (c, cb) ->
  a = []
  [c, ctx, imgd, px] = getToolbox(c)
  if Uint8Array then a = new Uint8Array(new ArrayBuffer(px.length))
  i = 0
  while i < px.length
    a[i]=px[i]
    i=i+1
  nb(cb, a)

#gets a length, returns a new unsued Uint8Array
#i.e.:
#FE.newUint8Array(length, callback)
#FE.newUint8Array(length)
FE.newUint8Array = (l, cb) ->
  nb(cb, new Uint8Array(new ArrayBuffer(l)))

#runs over the rgba values of a canvas, applys filter for each rgba value
#lookup optimized with fe_rgab
#fe_rgba(canvas, filter, callback)
#fe_rgba(canvas, filter)
#returns fals if called without filter
#returns a new canvas if everything worked
#filter function must look something like this
#filter(r,g,b,a,i)-> ...
#filter(r,g,b,a) -> ...
#filter(r,g,b) -> ...
FE.rgba = fe_rgba = (c, p...) ->
  [cb, filter] = lff(p, null, false)
  #[filter, extended] = opd(p, null, false)
  if not isFunction(filter)
    derror('Filter not a function', 'FE.rgba error')
    nb(cb, false)
  [c, ctx, imgd, pxs] = FE.getCanvasToolbox(c)
  [w,h]=[c.width,c.height]
  #u8 = new Uint8Array(new ArrayBuffer(pxs.length))
  u8 = FE.newUint8Array(pxs.length)
  y = 0
  while y < h
    x = 0
    yw = y*w
    while x < w
      #i = (y*w + x) * 4
      i = (yw+x)*4
      #i= yw4+x*4
      r = i; g = i+1; b = i+2;a = i+3
      [u8[r],u8[g],u8[b],u8[a]] = filter(pxs[r],pxs[g],pxs[b],pxs[a], i)
      x=x+1
    y=y+1
  new_c = FE.byArray(u8, w,h)
  nb(cb, new_c)

#gets r,g,b values, the grayscale value, lookup optimized with fe_getGrayscaleValue
#fe_getGrayscaleValue(r,g,b)
#fe_getGrayscaleValue(r,g,b,cb)
#fe_getGrayscaleValue(r,g,b,a,cb) #we do nothing with a

FE.getGrayscaleValue = fe_getGrayscaleValue = (r,g,b,p...) -> 
  [cb,a]=lff(p)
  nb(cb, r*0.3+g*0.59+b*0.11)

#same as fe_getGrayscaleValue, but only supports sync calls
FE.getSyncGrayscaleValue = fe_getSyncGrayscaleValue = (r,g,b) -> 
  r*0.3+g*0.59+b*0.11

FE.origin = (c,cb) ->
  nb(cb, (c?.getAttribute('id') or c?.getAttribute('data-origin')))






#resizes a canvas to a new size
#FE.hardResize(canvas, new_width, new_height, callback)
#FE.scale(canvas, scale_factor)
#returns a canvas
FE.hardResize = (c, w, h, cb) ->
  [new_c, new_ctx]=FE.newCanvasToolbox(w, h)
  new_ctx.drawImage(c, 0, 0, w, h)
  nb(cb,new_c)

#the same as hard resize, but keeps the image pixely
FE.pixelyResize = (c,w,h,cb) ->
  [new_c, new_ctx]=FE.newCanvasToolbox(w, h)
  new_ctx?.webkitImageSmoothingEnabled = false
  new_ctx?.imageSmoothingEnabled = false
  new_ctx?.mozImageSmoothingEnabled = false
  new_ctx.drawImage(c, 0, 0, w, h)
  nb(cb,new_c)

#returns a mosaic of the current image 
#TODO might fit better somewhere else
#FE.mosaic(canvas, number of mosaic pieces on the width axis, number of mosaic piecesn on the hight axis, callback)
FE.mosaic = (c, nr_of_px_width, nr_of_px_height, cb) ->
  minicanvas = FE.pixelyResize(c, nr_of_px_width,nr_of_px_height)
  original_sized_canvas = FE.pixelyResize(minicanvas, c.width, c.height)
  nb(cb, original_sized_canvas)


#scales a canvas
#scale_factor should be something between 0 and n
#FE.scale(canvas, scale_factor, callback)
#FE.scale(canvas, scale_factor)
#returns a canvas
FE.scale = (c, p...) ->
  [cb, x]=lff(p, 1)
  new_width = c.width*x
  new_height = c.height*x
  [new_c, new_ctx]=FE.newCanvasToolboxByCanvas(c)
  new_ctx.drawImage(c, 0,0, new_width, new_height)
  nb(cb, new_c)

#cuts out a piece of an existing canvas
#FE.crop(canvas, crop_x, crop_y, crop_width, crop_height], callback)
#returns a canvas
FE.crop = (c, p...) ->
  [cb, crop_x, crop_y, crop_width, crop_height] = lff(p, 0, 0, c.width/2, c.height/2)
  [new_c, new_ctx]=FE.newCanvasToolbox(crop_width, crop_height, FE.origin(c))
  new_ctx.drawImage(c, crop_x, crop_y, crop_width, crop_height, 0,0,crop_width, crop_height)
  nb(cb,new_c)

#resize, #a soft resize function that tries to fit an image into a suitabler width or height
#FE.resize(canvas, max_width, max_height, min_width, min_height, preference, callback)
#FE.resize(canvas, max_width)
#preference is either "width" or "height", if not given it makes a best guess
FE.resize = (c, p...) ->
  max =
    width: null
    height: null

  min =
    width: null
    height: null

  [cb, max['width'], max['height'], min['width'], min['height'], first] = lff(p, DEFAULT_HEIGHT, null, null, null)
  second = null
  r =
    width: null
    height: null

  if first is 'width'
    second = 'height'
  else if first is 'height'
    second = 'width'
  else
    if c.height > c.width
      first = 'height'
      second = 'width'
      dlog('hochformat')
    else
      first = 'width'
      second = 'height'
      dlog('querformat')

  #scale down
  if max?[first] and (c?[first] > max?[first] or c?[second] > max?[second])
    #debugger
    r[second]=c[second]*max[first]/c[first]
    r[first]=max[first]
    if max?[second] and r?[second]>max?[second]
      #debugger
      r[first]=c[first]*max[second]/c[second]
      r[second]=max[second]
  
  #scale up
  else if min?[first] and (c?[first] < min?[first] or c?[second] > min?[second])
    #debugger
    r[first]=c[first] * min[second] / c[second]
    r[second]=min[second]
    if min?[first] and r?[first]<min?[first]
      r[second]=c[second]*min[first]/c[first]
      r[first]=min[first]
  else
    r[first]=c[first]
    r[second]=c[second]

  dlog('in resize')
  dlog(r)
  #debugger;
  [new_c, new_ctx] = FE.newCanvasToolbox(r.width, r.height, FE.origin(c))
  new_ctx.drawImage(c, 0,0, r.width, r.height)

  nb(cb, new_c)

FE.scaleDownTo = (c, p...) ->
  [cb, max_width, max_height] = lff(p)
  FE.resize(c, max_width, max_height, cb)

FE.scaleUpTo = (c, p...) ->
  [cb, min_width, min_height] = lff(p)
  #FE.resize(c, null, null, min_width, min_height, cb)
  debugger;
  FE.resize(c,null,null,min_width,min_width,cb)


FE.rotateRight = (c, cb) ->
  [new_c, new_ctx] = FE.newCanvasToolbox(c.height,c.width)
  new_ctx.rotate(90*Math.PI/180)
  new_ctx.drawImage(c,0,c.height*-1)
  nb(cb,new_c)

FE.rotateLeft =  (c, cb) ->
  [new_c, new_ctx] = FE.newCanvasToolbox(c.height,c.width)
  new_ctx.rotate((90*(-1))*Math.PI/180)
  new_ctx.drawImage(c,c.width*-1,0)
  nb(cb,new_c)

#this method rotates an image (pos to the right, neg to the left)
#the resulting canvas contains the full pic (has the hight and width the diagonale)
#FE.rotate = (c, p...) ->
#  [cb, deg] = lff(p,45)

FE.flip = (c, cb) ->
  [new_c, new_ctx] = FE.newCanvasToolbox(c)
  new_ctx.rotate(Math.PI)
  new_ctx.drawImage(c,c.width*-1,c.height*-1)
  nb(cb,new_c)

FE.mirror = (c, cb) ->
  [new_c, new_ctx] = FE.newCanvasToolbox(c)
  new_ctx.translate(new_c.width / 2,0)
  new_ctx.scale(-1, 1)
  new_ctx.drawImage(c,(new_c.width / 2)*-1,0)
  nb(cb,new_c)
#all filters that work - in a simple way - on the rgba values of the imagedata, one pixel at a time

#multiply the rgba values of each pixel with the given values
#mr,mg,mb,ma should be between 0 and n
#FE.rgbaMultiplycanvas, mr=1,mg=1,mb=1,ma=1, callback)
#FE.rgbaMultiplycanvas, mr,mg,mb,ma)
#returns a canvas
FE.rgbaMultiply = (c, p...) ->
  [cb, rv, gv, bv, av] = lff(p,1,1,1,1)
  FE.rgba(c,cb,(r,g,b,a)->[fe_clamp(a*av),fe_clamp(g*gv),fe_clamp(b*bv),fe_clamp(a*av)])

#makes the rgb values of each pixel brighter
#p should be between 0 and n
#FE.brighter(canvas,p, callback)
#FE.brighter(canvas,p)
FE.brighter = (c,p...)->
  [cb, p]=lff(p,1)
  FE.rgbaMultiply(c, p,p,p,1,cb)

#makes the rgb values of each pixel darker
#p should be between 0 and 2 (1 means no change)
#FE.darker(canvas,p, callback)
#FE.darker(canvas,p)
FE.darker = (c,p...)->
  [cb, p]=lff(p,1)
  p=2-p
  FE.rgbaMultiply(c, p,p,p,1,cb)

#changes tha transparency "a" value of each pixel
#p should be between 0 and n
#FE.brighter(canvas,p, callback)
#FE.brighter(canvas,p)
FE.opacity = (c,p...) ->
  [cb,o]=lff(p,1)
  FE.rgbaMultiply(c,1,1,1,o,cb)

#does nothing
FE.nothing = (c, p...) ->
  [cb] = lff(p)
  filter = (r,g,b,a) -> [r,g,b,a]
  FE.rgba(c,filter,cb)

#inverts a canvas
#p must be between 0 and 1
#FE.invert(canvas, p=1, callback)
#FE.invert(canvas, p)
#FE.invert(canvas)
FE.invert = (c,p...)->
  [cb, p]=lff(p,1)
  #console.log(invert)
  until p>=0 and p<=1 then p=1
  p255 = p*255
  FE.rgba(c,((r,g,b,a)->[fe_pos(p255-r),fe_pos(p255-g),fe_pos(p255-b),a]),cb)

FE.saturate =  (c, p...) ->
  [cb, t]=lff(p, 0.3)
  filter = (r,g,b,a) ->
    average = (r+g+b)/3
    [
      fe_clamp(average + t * (r - average))
      fe_clamp(average + t * (g - average))
      fe_clamp(average + t * (b - average))
      a
    ]
  FE.rgba(c, filter, cb) #important, callback must be first function

FE.desaturate = (c, p...) ->
  [cb, t]=lff(p, 0.7)
  FE.saturate(c,1-t,cb)

#fill a canvas with a given color
FE.fill = (c, p...) ->
  [cb, rv, gv, bv] = lff(p,0,0,0)
  FE.rgba(c, ((r,g,b,a)->[clamp(rv), clamp(gv), clamp(bv), a]), cb)

#native posterize implementation
FE.posterize = (c, p...) ->
  [cb, levels]=lff(p,5)
  step = Math.floor(255 / levels)
  filter = (r,g,b,a) ->
    r2 = fe_clamp(Math.floor(r / step) * step)
    g2 = fe_clamp(Math.floor(g / step) * step)
    b2 = fe_clamp(Math.floor(b / step) * step)
    return [r2, g2, b2, a]
  FE.rgba(c,filter,cb)

FE.gray = (c, cb) ->
  filter = (r,g,b,a) ->
    average = (r+g+b)/3
    return [average, average, average, a]
  rgba(c, filter, cb)

FE.grayScale = (c, cb) ->
  filter = (r,g,b,a) ->
    f = fe_getSyncGrayscaleValue(r,g,b)
    return [f,f,f,a]
  rgba(c,filter,cb)

FE.tint = (c, p...) ->
  tint_min = 85
  tint_max = 170
  [cb, min_r, min_g, min_b, max_r, max_b, max_g]=lff(p,tint_min,tint_min,tint_min,tint_max,tint_max,tint_max)
  if min_r is max_r then max_r = max_r+1
  if min_g is max_g then max_g = max_g+1
  if min_b is max_b then max_b = max_b+1
  filter = (r,g,b,a) ->
    r2 = fe_clamp((r - min_r) * ((255 / (max_r - min_r))))
    g2 = fe_clamp((g - min_r) * ((255 / (max_g - min_g))))
    b2 = fe_clamp((b - min_b) * ((255 / (max_b - min_b))))
    return [r2,g2,b2,a]
  FE.rgba(c, filter, cb)

FE.sepia = (c, cb) ->
  filter = (r,g,b,a) ->
    r2 = (r * 0.393) + (g * 0.769) + (b * 0.189)
    g2 = (r * 0.349) + (g * 0.686) + (b * 0.168)
    b2 = (r * 0.272) + (g * 0.534) + (b * 0.131)
    return [fe_clamp(r2), fe_clamp(g2), fe_clamp(b2), a]
  FE.rgba(c, filter, cb)

FE.solarize = (c, cb) ->
  filter = (r,g,b,a) -> [
    (if r > 127 then 255-r else r)
    (if g > 127 then 255-g else g)
    (if b > 127 then 255-b else b)
    a
    ]
  FE.rgba(c,filter,cb)

FE.screen =  (c, p...) ->
  [cb, rr, gg, bb, strength] = fff(p, 227, 12, 169, 0.2)
  filter = (r,g,b,a) ->
    [
      (255 - ((255 - r) * (255 - rr * strength) / 255))
      (255 - ((255 - g) * (255 - gg * strength) / 255))
      (255 - ((255 - b) * (255 - bb * strength) / 255))
      a
    ]
  FE.rgba(c,filter,cb)

FE.noise = (c, p...) ->
  [cb, amount]=lff(p,20)
  [new_c, new_ctx, new_imgd, new_pxs]=FE.getCanvasToolbox(copy(c))
  for px, i in new_pxs
    noise = Math.round(amount - Math.random() * amount/2)
    dblHlp = 0
    k=0
    while k<3
      new_pxs[i+k] = fe_clamp(noise + new_pxs[i+k])
      k=k+1
  new_ctx.putImageData(new_imgd,0,0)
  nb(cb, new_c)



#socket = io.connect('http://localhost')
#socket.on('news', (data) ->
#  console.log(data)
#  socket.emit('my other event', { my: 'data' })
#)