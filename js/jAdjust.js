
jQuery(function() {
  $.jAdjust = function(element, options) {
    var state;
    state = '';
    this.settings = {};
    this.$element = $(element);
    this.setState = function(_state) {
      return state = _state;
    };
    this.getState = function() {
      return state;
    };
    this.getSetting = function(key) {
      return this.settings[key];
    };
    this.callSettingFunction = function(name, args) {
      if (args == null) {
        args = [];
      }
      return this.settings[name].apply(this, args);
    };
    this.init = function() {
      this.settings = $.extend({}, this.defaults, options);
      return this.setState('ready');
    };
    this.init();
    return this;
  };
  $.jAdjust.prototype.defaults = {
    initialZoom: 2,
    containerWidth: 272,
    containerHeight: 300
  };
  return $.fn.jAdjust = function(options) {
    return this.each(function() {
      var plugin;
      if ($(this).data('jAdjust') === void 0) {
        plugin = new $.jAdjust(this, options);
        return $(this).data('jAdjust', plugin);
      }
    });
  };
});
