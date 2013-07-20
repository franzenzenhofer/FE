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


