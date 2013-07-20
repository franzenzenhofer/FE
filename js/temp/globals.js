(function() {
  var DEFAULT_HEIGHT, DEFAULT_WIDTH, FE, MS_PSEUDO_NONBLOCKING, root, _DEBUG_, _defaultCallback;

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

}).call(this);
