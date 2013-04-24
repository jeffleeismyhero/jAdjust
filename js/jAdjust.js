var Adjuster, Image;

Image = (function() {

  function Image(element, options) {
    this.element = element;
    this.options = options;
    this.element.css({});
    return this.element;
  }

  return Image;

})();

Adjuster = (function() {

  function Adjuster(element, options) {
    this.element = element;
    this.options = options;
    this.state = 'waiting';
    this.size = {
      height: this.element.height(),
      width: this.element.width()
    };
    this.element.wrap("<div class='" + this.options.containerClass + "' style='position: relative; overflow: hidden;'/>");
    this.container = this.element.parent();
    this.initImage();
  }

  Adjuster.prototype.appendControls = function() {
    var _this = this;
    this.container.after("<div class='" + this.options.controlsClass + "' />");
    this.controls = $("." + this.options.controlsClass);
    if (this.options.zoomControlType === 'links') {
      this.controls.append(this.zoomOutLink()).append(this.zoomInLink());
    } else {
      this.controls.append(this.zoomSlider());
    }
    this.zoomInLink().on('click', function() {
      if (_this.options.currentZoomStep < _this.options.zoomSteps) {
        _this.zoomIn();
      }
      return false;
    });
    return this.zoomOutLink().on('click', function() {
      if (_this.options.currentZoomStep > 1) {
        _this.zoomOut();
      }
      return false;
    });
  };

  Adjuster.prototype.zoomInLink = function() {
    return this.$zoomInLink || (this.$zoomInLink = $('<a />', {
      html: this.options.zoomInBtnContent,
      "class": this.options.zoomInBtnClass,
      href: '#'
    }));
  };

  Adjuster.prototype.zoomOutLink = function() {
    return this.$zoomOutLink || (this.$zoomOutLink = $('<a />', {
      html: this.options.zoomOutBtnContent,
      "class": this.options.zoomOutBtnClass,
      href: '#'
    }));
  };

  Adjuster.prototype.zoomSlider = function() {
    var minZoom,
      _this = this;
    if (this.options.initialZoomStep === 0) {
      minZoom = this.options.currentZoomStep || 0;
    } else {
      minZoom = 1;
    }
    return $('<div />', {
      "class": this.options.zoomSliderClass
    }).slider({
      range: 'max',
      min: minZoom,
      max: this.options.zoomSteps,
      value: this.options.currentZoomStep,
      slide: function(ev, ui) {
        return _this.calculateSliderZoom(ev, ui);
      }
    });
  };

  Adjuster.prototype.initImage = function() {
    this.image = new Image(this.element, this.options);
    return this.element.css({
      width: this.size.width,
      top: 0,
      left: 0
    });
  };

  Adjuster.prototype.hideImage = function() {
    return this.image.hide();
  };

  Adjuster.prototype.showImage = function() {
    return this.image.show();
  };

  Adjuster.prototype.zoomIn = function() {
    if (this.options.currentZoomStep != null) {
      this.options.currentZoomStep += 1;
    } else {
      this.options.currentZoomStep = 1;
    }
    return this.setZoom(this.options.currentZoomStep);
  };

  Adjuster.prototype.zoomOut = function() {
    if (this.options.currentZoomStep > 0) {
      this.options.currentZoomStep -= 1;
    }
    return this.setZoom(this.options.currentZoomStep);
  };

  Adjuster.prototype.setZoom = function(zoomStep) {
    var imageHeight, imageWidth;
    this.$originalWidth || (this.$originalWidth = this.image[0].width);
    this.$originalHeight || (this.$originalHeight = this.image[0].height);
    "" + ((this.$originalWidth / this.options.zoomSteps) * zoomStep);
    imageWidth = (this.$originalWidth / this.options.zoomSteps) * zoomStep;
    imageHeight = (this.$originalHeight / this.options.zoomSteps) * zoomStep;
    this.image.width(imageWidth).height(imageHeight);
    this.setDraggability();
    return this.setCoordinates([this.image.width(), this.image.height(), this.image.position().left, this.image.position().top]);
  };

  Adjuster.prototype.setCrop = function() {};

  Adjuster.prototype.setDraggability = function() {
    var _this = this;
    this.image.draggable({
      opacity: 0.45,
      stop: function(ev, ui) {
        return _this.calculateCoordinates(ev, ui);
      }
    });
    return this.image.css({
      cursor: 'move'
    });
  };

  Adjuster.prototype.calculateCoordinates = function(ev, ui) {
    var h, hel, left, pos, top, v;
    hel = ui.helper;
    pos = ui.position;
    top = 0;
    left = 0;
    h = -(hel.outerHeight() - $(hel).parent().outerHeight());
    if (pos.top >= 0) {
      hel.animate({
        top: 0
      }, {
        duration: 100
      });
      top = 0;
    } else if (pos.top <= h) {
      hel.animate({
        top: h
      }, {
        duration: 100
      });
      top = h;
    } else {
      top = pos.top;
    }
    v = -(hel.outerWidth() - $(hel).parent().outerWidth());
    if (pos.left >= 0) {
      hel.animate({
        left: 0
      }, {
        duration: 100
      });
      left = 0;
    } else if (pos.left <= v) {
      hel.animate({
        left: v
      }, {
        duration: 100
      });
      left = v;
    } else {
      left = pos.left;
    }
    return this.setCoordinates([hel.width(), hel.height(), left, top]);
  };

  Adjuster.prototype.setCoordinates = function(coords) {};

  Adjuster.prototype.repositionImage = function() {
    if (this.image.width() < this.container.width() || this.image.height() < this.container.height()) {
      this.image.animate({
        left: 0,
        top: 0
      });
    }
    if ((this.container.width() - this.image.width() - this.image.position().left) > 0) {
      this.image.animate({
        left: 0,
        top: 0
      });
    }
    if ((this.container.height() - this.image.height() - this.image.position().top) > 0) {
      return this.image.animate({
        left: 0,
        top: 0
      });
    }
  };

  Adjuster.prototype.calculateSliderZoom = function(ev, ui) {
    if (ui.value >= this.options.currentZoomStep) {
      return this.zoomIn();
    } else {
      this.zoomOut();
      return this.repositionImage();
    }
  };

  Adjuster.prototype.sizeContainer = function(containerWidth, containerHeight) {
    return this.container.width(containerWidth).height(containerHeight);
  };

  Adjuster.prototype.sizeImage = function() {
    var x, _i, _ref, _results, _results1;
    if (this.options.initialZoomStep === 0 && !(this.options.currentZoomStep != null)) {
      _results = [];
      while (true) {
        if ((this.options.currentZoomStep != null) && this.image.width() >= this.container.width() && this.image.height() >= this.container.height()) {
          break;
        }
        if (this.options.currentZoomStep >= this.options.zoomSteps) {
          break;
        }
        _results.push(this.zoomIn());
      }
      return _results;
    } else {
      _results1 = [];
      for (x = _i = 1, _ref = this.options.initialZoomStep; _i <= _ref; x = _i += 1) {
        _results1.push(this.zoomIn());
      }
      return _results1;
    }
  };

  return Adjuster;

})();

$(function() {
  $.jAdjust = function(element, options) {
    this.defaults = {
      hideImage: true,
      containerClass: 'jAdjust',
      containerWidth: 272,
      containerHeight: 300,
      controlsClass: 'controls',
      controlsHeight: 26,
      showControls: true,
      controlsBackground: '#000',
      zoomControlType: 'links',
      zoomInBtnContent: '&#43;',
      zoomOutBtnContent: '&#45;',
      zoomInBtnClass: 'zoom-in-button',
      zoomOutBtnClass: 'zoom-out-button',
      zoomSliderClass: 'zoom-slider',
      zoomSteps: 10,
      initialZoomStep: 0,
      debug: true,
      onLoad: function() {},
      onVisible: function() {},
      onReady: function() {}
    };
    this.settings = {};
    this.$element = $(element);
    this.adjuster = {};
    this.getSetting = function(settingKey) {
      return this.settings[settingKey];
    };
    this.callSettingFunction = function(functionName) {
      return this.settings[functionName]();
    };
    this.settings = $.extend({}, this.defaults, options);
    this.adjuster = new Adjuster(this.$element, this.settings);
    this.hideImage = function() {
      return this.adjuster.hideImage();
    };
    this.showImage = function() {
      return this.adjuster.showImage();
    };
    this.init = function() {
      var height, width;
      this.callSettingFunction('onLoad');
      if (this.getSetting('hideImage')) {
        this.hideImage();
      }
      if (width = this.getSetting('containerWidth')) {
        if (height = this.getSetting('containerHeight')) {
          this.adjuster.sizeContainer(width, height);
          this.adjuster.sizeImage();
        }
      }
      if (this.getSetting('showControls')) {
        this.adjuster.appendControls();
      }
      this.callSettingFunction('onReady');
      return this.showImage();
    };
    this.init();
    return this;
  };
  return $.fn.jAdjust = function(options) {
    return this.each(function() {
      var plugin;
      if (void 0 === $(this).data('jAdjust')) {
        plugin = new $.jAdjust(this, options);
        return $(this).data('jAdjust', plugin);
      }
    });
  };
});
