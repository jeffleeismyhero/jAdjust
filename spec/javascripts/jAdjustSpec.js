
describe('jAdjust', function() {
  var fixtures, options;
  options = {
    containerWidth: 272,
    containerHeight: 300,
    hideImage: true,
    containerClass: 'newClass'
  };
  fixtures = "<div id='fixtures'>                <img src='../../images/grid-image.jpg' class='jAdjust' />              </div>";
  beforeEach(function() {
    setFixtures(fixtures);
    return this.$element = $('#fixtures .jAdjust');
  });
  it('should be available on the jQuery object', function() {
    return expect($.fn.jAdjust).toBeDefined();
  });
  it('should be chainable', function() {
    return expect(this.$element.jAdjust(options)).toBe(this.$element);
  });
  it('should offer default values', function() {
    var plugin;
    plugin = new $.jAdjust(this.$element[0], options);
    return expect(plugin.defaults).toBeDefined();
  });
  it('should overwrites the settings', function() {
    var plugin;
    plugin = new $.jAdjust(this.$element[0], options);
    expect(plugin.settings.containerWidth).toBe(options.containerWidth);
    expect(plugin.settings.containerHeight).toBe(options.containerHeight);
    expect(plugin.settings.hideImage).toBe(options.hideImage);
    return expect(plugin.settings.containerClass).toBe(options.containerClass);
  });
  describe('init', function() {
    it('should wrap the element in the div with containerClass', function() {
      var $elementContainer, plugin;
      plugin = new $.jAdjust(this.$element);
      $elementContainer = plugin.$element.parent();
      return expect($elementContainer.hasClass(plugin.settings.containerClass)).toBeTruthy();
    });
    it('should set the container and element size', function() {
      var $element, $elementContainer, plugin;
      plugin = new $.jAdjust(this.$element, {
        controlsHeight: 26
      });
      $elementContainer = plugin.$element.parent();
      $element = plugin.$element;
      expect($elementContainer.width()).toBe(options.containerWidth);
      return expect($elementContainer.height()).toBe(options.containerHeight);
    });
    it('should call hideImage on the image by default', function() {
      var plugin;
      plugin = new $.jAdjust(this.$element);
      spyOn(plugin, 'init').andCallThrough();
      spyOn(plugin, 'hideImage').andCallThrough();
      expect(plugin.hideImage).toBeDefined();
      plugin.init();
      expect(plugin.hideImage).toHaveBeenCalled();
      expect(this.$element.is(":hidden")).toBeTruthy();
      expect(plugin.adjuster instanceof Adjuster).toBeTruthy();
      return expect(this.$element.prop('tagName')).toBe('IMG');
    });
    return it('should call showImage on the image when hideImage is false', function() {
      var plugin;
      plugin = new $.jAdjust(this.$element, {
        hideImage: false
      });
      spyOn(plugin, 'init').andCallThrough();
      spyOn(plugin, 'showImage').andCallThrough();
      expect(plugin.showImage).toBeDefined();
      plugin.init();
      expect(plugin.showImage).toHaveBeenCalled();
      plugin.showImage();
      expect(plugin.adjuster instanceof Adjuster).toBeTruthy();
      return expect(this.$element.prop('tagName')).toBe('IMG');
    });
  });
  return describe('controls', function() {
    return describe('zoom links', function() {
      it('should generate the zoom links by default', function() {
        var plugin;
        plugin = new $.jAdjust(this.$element);
        expect($(".controls a." + plugin.settings.zoomInBtnClass)).toExist();
        expect($(".controls a." + plugin.settings.zoomOutBtnClass)).toExist();
        expect($(".controls a." + plugin.settings.zoomInBtnClass)).toHaveText($('<div />').html(plugin.settings.zoomInBtnContent).text());
        return expect($(".controls a." + plugin.settings.zoomOutBtnClass)).toHaveText($('<div />').html(plugin.settings.zoomOutBtnContent).text());
      });
      return it('should generate the zoom slider on request', function() {
        var plugin;
        plugin = new $.jAdjust(this.$element, {
          zoomControlType: 'slider'
        });
        expect($(".controls ." + plugin.settings.zoomSliderClass)).toExist();
        expect($(".controls ." + plugin.settings.zoomSliderClass).slider("option", "max")).toBe(plugin.settings.zoomSteps);
        expect($(".controls ." + plugin.settings.zoomSliderClass).slider("option", "min")).toBe(plugin.settings.currentZoomStep);
        expect($(".controls ." + plugin.settings.zoomSliderClass).slider("option", "range")).toBe("max");
        return expect($(".controls ." + plugin.settings.zoomSliderClass).slider("option", "value")).toBe(plugin.settings.currentZoomStep);
      });
    });
  });
});
