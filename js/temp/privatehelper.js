(function() {
  var cbr, derror, dlog, isFunction, lff, nb, opd,
    __slice = [].slice;

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
      console.log('hiho' + i);
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

  console.log('lff now');

  console.log(lff([0, 1, 2, 3, 4, 5, (function() {}), 6]));

  console.log('lff now 2');

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

}).call(this);
