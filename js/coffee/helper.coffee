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





