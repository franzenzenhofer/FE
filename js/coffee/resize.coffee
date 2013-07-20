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

