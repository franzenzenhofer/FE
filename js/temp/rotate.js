(function() {

  FE.rotateRight = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(c.height, c.width), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate(90 * Math.PI / 180);
    new_ctx.drawImage(c, 0, c.height * -1);
    return nb(cb, new_c);
  };

  FE.rotateLeft = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(c.height, c.width), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate((90 * (-1)) * Math.PI / 180);
    new_ctx.drawImage(c, c.width * -1, 0);
    return nb(cb, new_c);
  };

  FE.flip = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate(Math.PI);
    new_ctx.drawImage(c, c.width * -1, c.height * -1);
    return nb(cb, new_c);
  };

  FE.mirror = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.translate(new_c.width / 2, 0);
    new_ctx.scale(-1, 1);
    new_ctx.drawImage(c, (new_c.width / 2) * -1, 0);
    return nb(cb, new_c);
  };

}).call(this);
