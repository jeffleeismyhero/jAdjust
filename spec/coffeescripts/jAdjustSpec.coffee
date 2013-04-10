describe 'jAdjust', ->
  options =
    width: 272
    height: 300
    show: false
    containerClass: 'newClass'
  fixtures = "<div id='fixtures'>
                <img src='../../images/grid-image.jpg' class='jAdjust' />
              </div>"

  beforeEach ->
    setFixtures fixtures
    @$element = $('#fixtures .jAdjust')

  it 'should be available on the jQuery object', ->
    expect($.fn.jAdjust).toBeDefined()

  it 'should be chainable', ->
    expect(@$element.jAdjust(options)).toBe @$element

  it 'should offer default values', ->
    plugin = new $.jAdjust(@$element[0], options)

    expect(plugin.defaults).toBeDefined()

  it 'should overwrites the settings', ->
    plugin = new $.jAdjust(@$element[0], options)

    expect(plugin.settings.width).toBe options.width
    expect(plugin.settings.height).toBe options.height
    expect(plugin.settings.show).toBe options.show
    expect(plugin.settings.containerClass).toBe options.containerClass

  describe 'init', ->
    it 'should wrap the element in the div with containerClass', ->
      plugin = new $.jAdjust(@$element)
      $elementContainer = plugin.$element.parent()
      expect($elementContainer.hasClass(plugin.settings.containerClass)).toBeTruthy() 

    it 'should set the container and element size', ->
      plugin = new $.jAdjust(@$element, {controlsHeight: 26})
      $elementContainer = plugin.$element.parent()
      $element = plugin.$element

      expect($elementContainer.width()).toBe options.width
      expect($elementContainer.height()).toBe (options.height + 26)
      expect($element.width()).toBe options.width
      expect($element.height()).toBe options.height

    it 'should call showElement on the image by default', ->
      plugin = new $.jAdjust(@$element)
      spyOn(plugin, 'showElement')

      plugin.init()
      expect(plugin.showElement).toHaveBeenCalled()

    it 'should not show the image if show is true', ->
      plugin = new $.jAdjust(@$element, {show: true})
      spyOn(plugin, 'showElement')

      plugin.init()
      expect(plugin.showElement).not.toHaveBeenCalled()

    it 'should add a control div', ->
      plugin = new $.jAdjust(@$element)
      $elementContainer = plugin.$element.parent()
      expect($elementContainer.has("div.controls")).toBeTruthy()