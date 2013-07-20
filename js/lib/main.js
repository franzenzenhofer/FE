/*! franze - v0.0.1 - last build: 2013-07-20 22:15:50 */
(function() {
  var DEFAULT_HEIGHT, DEFAULT_WIDTH, FE, MS_PSEUDO_NONBLOCKING, cbr, derror, dlog, fe_clamp, fe_getGrayscaleValue, fe_getSyncGrayscaleValue, fe_pos, fe_rgba, isFunction, lff, nb, opd, root, _DEBUG_, _defaultCallback,
    __slice = [].slice;

  FE = {};

  root = window || (typeof module !== "undefined" && module !== null ? module.exports : void 0) || this;

  root.FE = FE;

  _DEBUG_ = false;

  MS_PSEUDO_NONBLOCKING = 0;

  _defaultCallback = function(c) {
    return c;
  };

  DEFAULT_WIDTH = 800;

  DEFAULT_HEIGHT = 600;

  dlog = function(msg) {
    if (_DEBUG_) {
      return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
    }
  };

  derror = function(msg, error_name) {
    if (error_name == null) {
      error_name = "Debug Error";
    }
    if (_DEBUG_) {
      throw new Error(error_name + ': ' + msg);
    }
  };

  cbr = function(cb, function_name) {
    var _results;
    _results = [];
    while (!cb) {
      throw new Error('Callback required for ' + function_name);
    }
    return _results;
  };

  isFunction = function(functionToCheck) {
    var getType;
    getType = {};
    return functionToCheck && getType.toString.apply(functionToCheck) === '[object Function]';
  };

  nb = function() {
    var cb, p;
    cb = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    if (cb && isFunction(cb)) {
      root.setTimeout.apply(root, [cb, MS_PSEUDO_NONBLOCKING].concat(__slice.call(p)));
    }
    if (p.length === 1) {
      return p[0];
    }
    return p;
  };

  lff = function() {
    var d, defaults, i, last_func, p2, par, params, _fn, _i, _len;
    params = arguments[0], defaults = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    dlog('call to lff');
    dlog(params);
    dlog(defaults);
    last_func = null;
    p2 = [];
    i = 0;
    i = params.length - 1;
    while (i >= 0) {
      par = params[i];
      if (isFunction(par) && !last_func) {
        last_func = par;
      } else {
        p2.unshift(par);
      }
      i = i - 1;
    }
    _fn = function(d) {
      var _ref;
      return (_ref = p2[i]) != null ? _ref : p2[i] = d;
    };
    for (i = _i = 0, _len = defaults.length; _i < _len; i = ++_i) {
      d = defaults[i];
      _fn(d);
    }
    if (!last_func) {
      last_func = _defaultCallback;
    }
    p2.unshift(last_func);
    return p2;
  };

  opd = function() {
    var defaults, i, par, params, r, _fn, _i, _len;
    params = arguments[0], defaults = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    r = [];
    _fn = function(par, i) {
      return r[i] = typeof p !== "undefined" && p !== null ? p : defaults != null ? defaults[i] : void 0;
    };
    for (i = _i = 0, _len = params.length; _i < _len; i = ++_i) {
      par = params[i];
      _fn(par, i);
    }
    return r;
  };

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

  FE.rgbaMultiply = function() {
    var av, bv, c, cb, gv, p, rv, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1, 1, 1, 1), cb = _ref[0], rv = _ref[1], gv = _ref[2], bv = _ref[3], av = _ref[4];
    return FE.rgba(c, cb, function(r, g, b, a) {
      return [fe_clamp(a * av), fe_clamp(g * gv), fe_clamp(b * bv), fe_clamp(a * av)];
    });
  };

  FE.brighter = function() {
    var c, cb, p, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1), cb = _ref[0], p = _ref[1];
    return FE.rgbaMultiply(c, p, p, p, 1, cb);
  };

  FE.darker = function() {
    var c, cb, p, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1), cb = _ref[0], p = _ref[1];
    p = 2 - p;
    return FE.rgbaMultiply(c, p, p, p, 1, cb);
  };

  FE.opacity = function() {
    var c, cb, o, p, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1), cb = _ref[0], o = _ref[1];
    return FE.rgbaMultiply(c, 1, 1, 1, o, cb);
  };

  FE.nothing = function() {
    var c, cb, filter, p;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    cb = lff(p)[0];
    filter = function(r, g, b, a) {
      return [r, g, b, a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.invert = function() {
    var c, cb, p, p255, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 1), cb = _ref[0], p = _ref[1];
    while (!(p >= 0 && p <= 1)) {
      p = 1;
    }
    p255 = p * 255;
    return FE.rgba(c, (function(r, g, b, a) {
      return [fe_pos(p255 - r), fe_pos(p255 - g), fe_pos(p255 - b), a];
    }), cb);
  };

  FE.saturate = function() {
    var c, cb, filter, p, t, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 0.3), cb = _ref[0], t = _ref[1];
    filter = function(r, g, b, a) {
      var average;
      average = (r + g + b) / 3;
      return [fe_clamp(average + t * (r - average)), fe_clamp(average + t * (g - average)), fe_clamp(average + t * (b - average)), a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.desaturate = function() {
    var c, cb, p, t, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 0.7), cb = _ref[0], t = _ref[1];
    return FE.saturate(c, 1 - t, cb);
  };

  FE.fill = function() {
    var bv, c, cb, gv, p, rv, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 0, 0, 0), cb = _ref[0], rv = _ref[1], gv = _ref[2], bv = _ref[3];
    return FE.rgba(c, (function(r, g, b, a) {
      return [clamp(rv), clamp(gv), clamp(bv), a];
    }), cb);
  };

  FE.posterize = function() {
    var c, cb, filter, levels, p, step, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 5), cb = _ref[0], levels = _ref[1];
    step = Math.floor(255 / levels);
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = fe_clamp(Math.floor(r / step) * step);
      g2 = fe_clamp(Math.floor(g / step) * step);
      b2 = fe_clamp(Math.floor(b / step) * step);
      return [r2, g2, b2, a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.gray = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var average;
      average = (r + g + b) / 3;
      return [average, average, average, a];
    };
    return rgba(c, filter, cb);
  };

  FE.grayScale = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var f;
      f = fe_getSyncGrayscaleValue(r, g, b);
      return [f, f, f, a];
    };
    return rgba(c, filter, cb);
  };

  FE.tint = function() {
    var c, cb, filter, max_b, max_g, max_r, min_b, min_g, min_r, p, tint_max, tint_min, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    tint_min = 85;
    tint_max = 170;
    _ref = lff(p, tint_min, tint_min, tint_min, tint_max, tint_max, tint_max), cb = _ref[0], min_r = _ref[1], min_g = _ref[2], min_b = _ref[3], max_r = _ref[4], max_b = _ref[5], max_g = _ref[6];
    if (min_r === max_r) {
      max_r = max_r + 1;
    }
    if (min_g === max_g) {
      max_g = max_g + 1;
    }
    if (min_b === max_b) {
      max_b = max_b + 1;
    }
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = fe_clamp((r - min_r) * (255 / (max_r - min_r)));
      g2 = fe_clamp((g - min_r) * (255 / (max_g - min_g)));
      b2 = fe_clamp((b - min_b) * (255 / (max_b - min_b)));
      return [r2, g2, b2, a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.sepia = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = (r * 0.393) + (g * 0.769) + (b * 0.189);
      g2 = (r * 0.349) + (g * 0.686) + (b * 0.168);
      b2 = (r * 0.272) + (g * 0.534) + (b * 0.131);
      return [fe_clamp(r2), fe_clamp(g2), fe_clamp(b2), a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.solarize = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      return [(r > 127 ? 255 - r : r), (g > 127 ? 255 - g : g), (b > 127 ? 255 - b : b), a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.screen = function() {
    var bb, c, cb, filter, gg, p, rr, strength, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 227, 12, 169, 0.2), cb = _ref[0], rr = _ref[1], gg = _ref[2], bb = _ref[3], strength = _ref[4];
    filter = function(r, g, b, a) {
      return [255 - ((255 - r) * (255 - rr * strength) / 255), 255 - ((255 - g) * (255 - gg * strength) / 255), 255 - ((255 - b) * (255 - bb * strength) / 255), a];
    };
    return FE.rgba(c, filter, cb);
  };

  FE.noise = function() {
    var amount, c, cb, dblHlp, i, k, new_c, new_ctx, new_imgd, new_pxs, noise, p, px, _i, _len, _ref, _ref1;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = lff(p, 20), cb = _ref[0], amount = _ref[1];
    _ref1 = FE.getCanvasToolbox(copy(c)), new_c = _ref1[0], new_ctx = _ref1[1], new_imgd = _ref1[2], new_pxs = _ref1[3];
    for (i = _i = 0, _len = new_pxs.length; _i < _len; i = ++_i) {
      px = new_pxs[i];
      noise = Math.round(amount - Math.random() * amount / 2);
      dblHlp = 0;
      k = 0;
      while (k < 3) {
        new_pxs[i + k] = fe_clamp(noise + new_pxs[i + k]);
        k = k + 1;
      }
    }
    new_ctx.putImageData(new_imgd, 0, 0);
    return nb(cb, new_c);
  };

}).call(this);
