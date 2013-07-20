(function() {
  var fe_clamp, fe_getGrayscaleValue, fe_getSyncGrayscaleValue, fe_pos, fe_rgba,
    __slice = [].slice;

  FE.clamp = fe_clamp = function(v, min, max) {
    if (min == null) {
      min = 0;
    }
    if (max == null) {
      max = 255;
    }
    return Math.min(max, Math.max(min, v));
  };

  FE.pos = fe_pos = function(v) {
    if (v < 0) {
      return v * -1;
    } else {
      return v;
    }
  };

  FE.getCanvasToolbox = function(c, cb) {
    var ctx, img_data, img_data_data;
    ctx = c.getContext('2d');
    dlog(ctx);
    dlog(c);
    dlog(c.width);
    dlog(c.height);
    img_data = ctx.getImageData(0, 0, c.width, c.height);
    img_data_data = img_data.data;
    return nb(cb, [c, ctx, img_data, img_data_data]);
  };

  FE.make = function() {
    var a, c, cb, element, height, object_or_width, origin, p, width, _ref;
    p = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    _ref = a = lff(p, DEFAULT_WIDTH, DEFAULT_HEIGHT), cb = _ref[0], object_or_width = _ref[1], height = _ref[2], origin = _ref[3];
    dlog('in make');
    dlog(a);
    if (object_or_width.width && object_or_width.height) {
      element = object_or_width;
      width = element.width;
      height = element.height;
      origin = (element != null ? typeof element.getAttribute === "function" ? element.getAttribute('id') : void 0 : void 0) || (element != null ? typeof element.getAttribute === "function" ? element.getAttribute('data-origin') : void 0 : void 0);
    } else {
      width = object_or_width;
    }
    c = root.document.createElement('canvas');
    c.width = width;
    c.height = height;
    if (origin) {
      c.setAttribute('origin', origin);
    }
    dlog(c);
    return nb(cb, c);
  };

  FE.newCanvasToolbox = function() {
    var cb, height, origin, p, width, _ref;
    p = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    _ref = lff(p), cb = _ref[0], width = _ref[1], height = _ref[2], origin = _ref[3];
    return FE.getCanvasToolbox(FE.make(width, height, origin), cb);
  };

  FE.newCanvasToolboxByCanvas = function(c, cb) {
    return FE.getCanvasToolbox(FE.make(c.width, c.height, FE.origin(c)), cb);
  };

  FE.copy = function() {
    var c, c2, c2_ctx, cb, p, _ref, _ref1, _ref2;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p), cb = _ref[0], c2 = _ref[1];
    if (c2) {
      _ref1 = FE.getCanvasToolbox(c), c2 = _ref1[0], c2_ctx = _ref1[1];
    } else {
      _ref2 = FE.newCanvasToolbox(c), c2 = _ref2[0], c2_ctx = _ref2[1];
    }
    dlog('hiho');
    c2_ctx.drawImage(c, 0, 0, c.width, c.height);
    dlog('cb of copy');
    dlog(cb);
    return nb(cb, c2);
  };

  FE.byImage = function(img, cb) {
    if (img.width && img.height) {
      dlog('loaded');
      return FE.copy(img, cb);
    } else {
      cbr(cb, 'FE.byImage (only if the image is not "loaded")');
      if (isFunction(cb)) {
        img.onload = function() {
          return FE.byImage(img, cb);
        };
      }
      return true;
    }
  };

  FE.byArray = function(a, w, h, cb) {
    var c, ctx, i, imgd, pxs, v, _fn, _i, _len, _ref;
    _ref = FE.newCanvasToolbox(w, h), c = _ref[0], ctx = _ref[1], imgd = _ref[2], pxs = _ref[3];
    i = 0;
    _fn = function(v, i) {
      return pxs[i] = a[i];
    };
    for (i = _i = 0, _len = pxs.length; _i < _len; i = ++_i) {
      v = pxs[i];
      _fn(v, i);
    }
    ctx.putImageData(imgd, 0, 0);
    return nb(cb, c);
  };

  FE.toImage = function() {
    var c, cb, img, mime, p, _ref;
    p = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    _ref = lff(p, FE.make(), 'image/png'), cb = _ref[0], c = _ref[1], mime = _ref[2];
    img = new Image();
    img.src = c.toDataURL(mime, "");
    return nb(cb, img);
  };

  FE.toArray = function(c, cb) {
    var a, ctx, i, imgd, px, _ref;
    a = [];
    _ref = getToolbox(c), c = _ref[0], ctx = _ref[1], imgd = _ref[2], px = _ref[3];
    if (Uint8Array) {
      a = new Uint8Array(new ArrayBuffer(px.length));
    }
    i = 0;
    while (i < px.length) {
      a[i] = px[i];
      i = i + 1;
    }
    return nb(cb, a);
  };

  FE.newUint8Array = function(l, cb) {
    return nb(cb, new Uint8Array(new ArrayBuffer(l)));
  };

  FE.rgba = fe_rgba = function() {
    var a, b, c, cb, ctx, filter, g, h, i, imgd, new_c, p, pxs, r, u8, w, x, y, yw, _ref, _ref1, _ref2, _ref3;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, null, false), cb = _ref[0], filter = _ref[1];
    if (!isFunction(filter)) {
      derror('Filter not a function', 'FE.rgba error');
      nb(cb, false);
    }
    _ref1 = FE.getCanvasToolbox(c), c = _ref1[0], ctx = _ref1[1], imgd = _ref1[2], pxs = _ref1[3];
    _ref2 = [c.width, c.height], w = _ref2[0], h = _ref2[1];
    u8 = FE.newUint8Array(pxs.length);
    y = 0;
    while (y < h) {
      x = 0;
      yw = y * w;
      while (x < w) {
        i = (yw + x) * 4;
        r = i;
        g = i + 1;
        b = i + 2;
        a = i + 3;
        _ref3 = filter(pxs[r], pxs[g], pxs[b], pxs[a], i), u8[r] = _ref3[0], u8[g] = _ref3[1], u8[b] = _ref3[2], u8[a] = _ref3[3];
        x = x + 1;
      }
      y = y + 1;
    }
    new_c = FE.byArray(u8, w, h);
    return nb(cb, new_c);
  };

  FE.getGrayscaleValue = fe_getGrayscaleValue = function() {
    var a, b, cb, g, p, r, _ref;
    r = arguments[0], g = arguments[1], b = arguments[2], p = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
    _ref = lff(p), cb = _ref[0], a = _ref[1];
    return nb(cb, r * 0.3 + g * 0.59 + b * 0.11);
  };

  FE.getSyncGrayscaleValue = fe_getSyncGrayscaleValue = function(r, g, b) {
    return r * 0.3 + g * 0.59 + b * 0.11;
  };

  FE.origin = function(c, cb) {
    return nb(cb, (c != null ? c.getAttribute('id') : void 0) || (c != null ? c.getAttribute('data-origin') : void 0));
  };

}).call(this);
