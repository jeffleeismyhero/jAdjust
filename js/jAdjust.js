
$(function() {
  $.jAdjust = function(element, options) {
    var addControls, addDebugData, setState, sizeElementAndContainer, state, wrapElement,
      _this = this;
    this.defaults = {
      width: 272,
      height: 300,
      show: false,
      time: 4000,
      showSpeed: 600,
      showEasing: '',
      hideEasing: '',
      containerClass: 'jAdjust',
      controlsClass: 'controls',
      controlsHeight: 26,
      controlsBackground: '#000',
      debug: true,
      onLoad: function() {},
      onVisible: function() {}
    };
    state = '';
    this.settings = {};
    this.$element = $(element);
    setState = function(_state) {
      return state = _state;
    };
    wrapElement = function() {
      _this.$elementContainer = $('<div />', {
        'class': _this.getSetting('containerClass')
      });
      return _this.$element.wrap(_this.$elementContainer);
    };
    sizeElementAndContainer = function() {
      _this.$elementContainer = _this.$element.parent();
      _this.$elementContainer.width(_this.getSetting('width'));
      _this.$elementContainer.height((_this.getSetting('height')) + (_this.getSetting('controlsHeight')));
      _this.$element.width(_this.getSetting('width'));
      return _this.$element.height(_this.getSetting('height'));
    };
    addControls = function() {
      _this.$element.css({
        display: 'block'
      });
      return _this.$elementContainer.append($('<div />', {
        'class': _this.getSetting('controlsClass')
      }).css({
        background: _this.getSetting('controlsBackground'),
        height: _this.getSetting('controlsHeight')
      }));
    };
    addDebugData = function() {
      return _this.$elementContainer.after($('<div />', {
        'class': 'jAdjust-debug'
      }).css({
        background: '#CCC',
        height: '200px',
        width: _this.getSetting('width'),
        float: 'left',
        clear: 'both',
        display: 'block'
      }));
    };
    this.getState = function() {
      return state;
    };
    this.getSetting = function(settingKey) {
      return this.settings[settingKey];
    };
    this.callSettingFunction = function(functionName) {
      return this.settings[functionName](element);
    };
    this.init = function() {
      setState('hidden');
      this.settings = $.extend({}, this.defaults, options);
      if ((this.getSetting('show')) === true) {
        this.$element.show();
        setState('visible');
      } else {
        this.$element.hide();
      }
      if (this.$element.length) {
        wrapElement();
        sizeElementAndContainer();
        addControls();
        if ((this.getSetting('debug')) === true) {
          addDebugData();
        }
        if (this.getState() !== 'showing' && this.getState() !== 'visible') {
          return this.showElement();
        }
      }
    };
    this.showElement = function() {
      var _this = this;
      if (this.getState() !== 'showing' && this.getState() !== 'visible') {
        setState('showing');
        this.callSettingFunction('onLoad');
        return this.$element.fadeIn(this.getSetting('showSpeed'), this.getSetting('showEasing'), function() {
          setState('visible');
          return _this.callSettingFunction('onVisible');
        });
      }
    };
    this.init();
    return this;
  };
  return $.fn.jAdjust = function(options) {
    return this.each(function() {
      var plugin;
      plugin = ($(this)).data('jAdjust');
      if (plugin === void 0) {
        plugin = new $.jAdjust(this, options);
        return ($(this)).data('jAdjust', plugin);
      } else {
        return plugin.show();
      }
    });
  };
});
