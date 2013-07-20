(function() {
  var __slice = [].slice;

  FE.hardResize = function(c, w, h, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(w, h), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.drawImage(c, 0, 0, w, h);
    return nb(cb, new_c);
  };

  FE.pixelyResize = function(c, w, h, cb) {
    var new_c, new_ctx, _ref;
    _ref = FE.newCanvasToolbox(w, h), new_c = _ref[0], new_ctx = _ref[1];
    if (new_ctx != null) {
      new_ctx.webkitImageSmoothingEnabled = false;
    }
    if (new_ctx != null) {
      new_ctx.imageSmoothingEnabled = false;
    }
    if (new_ctx != null) {
      new_ctx.mozImageSmoothingEnabled = false;
    }
    new_ctx.drawImage(c, 0, 0, w, h);
    return nb(cb, new_c);
  };

  FE.mosaic = function(c, nr_of_px_width, nr_of_px_height, cb) {
    var minicanvas, original_sized_canvas;
    minicanvas = FE.pixelyResize(c, nr_of_px_width, nr_of_px_height);
    original_sized_canvas = FE.pixelyResize(minicanvas, c.width, c.height);
    return nb(cb, original_sized_canvas);
  };

  FE.scale = function() {
    var c, cb, new_c, new_ctx, new_height, new_width, p, x, _ref, _ref1;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1), cb = _ref[0], x = _ref[1];
    new_width = c.width * x;
    new_height = c.height * x;
    _ref1 = FE.newCanvasToolboxByCanvas(c), new_c = _ref1[0], new_ctx = _ref1[1];
    new_ctx.drawImage(c, 0, 0, new_width, new_height);
    return nb(cb, new_c);
  };

  FE.crop = function() {
    var c, cb, crop_height, crop_width, crop_x, crop_y, new_c, new_ctx, p, _ref, _ref1;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 0, 0, c.width / 2, c.height / 2), cb = _ref[0], crop_x = _ref[1], crop_y = _ref[2], crop_width = _ref[3], crop_height = _ref[4];
    _ref1 = FE.newCanvasToolbox(crop_width, crop_height, FE.origin(c)), new_c = _ref1[0], new_ctx = _ref1[1];
    new_ctx.drawImage(c, crop_x, crop_y, crop_width, crop_height, 0, 0, crop_width, crop_height);
    return nb(cb, new_c);
  };

  FE.resize = function() {
    var c, cb, first, max, min, new_c, new_ctx, p, r, second, _ref, _ref1;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    max = {
      width: null,
      height: null
    };
    min = {
      width: null,
      height: null
    };
    _ref = lff(p, DEFAULT_HEIGHT, null, null, null), cb = _ref[0], max['width'] = _ref[1], max['height'] = _ref[2], min['width'] = _ref[3], min['height'] = _ref[4], first = _ref[5];
    second = null;
    r = {
      width: null,
      height: null
    };
    if (first === 'width') {
      second = 'height';
    } else if (first === 'height') {
      second = 'width';
    } else {
      if (c.height > c.width) {
        first = 'height';
        second = 'width';
        dlog('hochformat');
      } else {
        first = 'width';
        second = 'height';
        dlog('querformat');
      }
    }
    if ((max != null ? max[first] : void 0) && ((c != null ? c[first] : void 0) > (max != null ? max[first] : void 0) || (c != null ? c[second] : void 0) > (max != null ? max[second] : void 0))) {
      r[second] = c[second] * max[first] / c[first];
      r[first] = max[first];
      if ((max != null ? max[second] : void 0) && (r != null ? r[second] : void 0) > (max != null ? max[second] : void 0)) {
        r[first] = c[first] * max[second] / c[second];
        r[second] = max[second];
      }
    } else if ((min != null ? min[first] : void 0) && ((c != null ? c[first] : void 0) < (min != null ? min[first] : void 0) || (c != null ? c[second] : void 0) > (min != null ? min[second] : void 0))) {
      r[first] = c[first] * min[second] / c[second];
      r[second] = min[second];
      if ((min != null ? min[first] : void 0) && (r != null ? r[first] : void 0) < (min != null ? min[first] : void 0)) {
        r[second] = c[second] * min[first] / c[first];
        r[first] = min[first];
      }
    } else {
      r[first] = c[first];
      r[second] = c[second];
    }
    dlog('in resize');
    dlog(r);
    _ref1 = FE.newCanvasToolbox(r.width, r.height, FE.origin(c)), new_c = _ref1[0], new_ctx = _ref1[1];
    new_ctx.drawImage(c, 0, 0, r.width, r.height);
    return nb(cb, new_c);
  };

  FE.scaleDownTo = function() {
    var c, cb, max_height, max_width, p, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p), cb = _ref[0], max_width = _ref[1], max_height = _ref[2];
    return FE.resize(c, max_width, max_height, cb);
  };

  FE.scaleUpTo = function() {
    var c, cb, min_height, min_width, p, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p), cb = _ref[0], min_width = _ref[1], min_height = _ref[2];
    debugger;
    return FE.resize(c, null, null, min_width, min_width, cb);
  };

}).call(this);
