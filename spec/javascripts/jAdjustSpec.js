
describe('jAdjust', function() {
  var fixtures, options;
  options = {
    width: 272,
    height: 300,
    show: false,
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
    expect(plugin.settings.width).toBe(options.width);
    expect(plugin.settings.height).toBe(options.height);
    expect(plugin.settings.show).toBe(options.show);
    return expect(plugin.settings.containerClass).toBe(options.containerClass);
  });
  return describe('init', function() {
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
      expect($elementContainer.width()).toBe(options.width);
      expect($elementContainer.height()).toBe(options.height + 26);
      expect($element.width()).toBe(options.width);
      return expect($element.height()).toBe(options.height);
    });
    it('should call showElement on the image by default', function() {
      var plugin;
      plugin = new $.jAdjust(this.$element);
      spyOn(plugin, 'showElement');
      plugin.init();
      return expect(plugin.showElement).toHaveBeenCalled();
    });
    it('should not show the image if show is true', function() {
      var plugin;
      plugin = new $.jAdjust(this.$element, {
        show: true
      });
      spyOn(plugin, 'showElement');
      plugin.init();
      return expect(plugin.showElement).not.toHaveBeenCalled();
    });
    return it('should add a control div', function() {
      var $elementContainer, plugin;
      plugin = new $.jAdjust(this.$element);
      $elementContainer = plugin.$element.parent();
      return expect($elementContainer.has("div.controls")).toBeTruthy();
    });
  });
});
