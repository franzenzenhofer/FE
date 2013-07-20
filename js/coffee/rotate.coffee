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