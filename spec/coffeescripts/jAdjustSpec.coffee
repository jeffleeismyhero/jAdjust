describe 'jAdjust', ->
  options =
    containerWidth: 272
    containerHeight: 300
    hideImage: true
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

    expect(plugin.settings.containerWidth).toBe options.containerWidth
    expect(plugin.settings.containerHeight).toBe options.containerHeight
    expect(plugin.settings.hideImage).toBe options.hideImage
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

      expect($elementContainer.width()).toBe options.containerWidth
      expect($elementContainer.height()).toBe options.containerHeight
      
    it 'should call hideImage on the image by default', ->
      plugin = new $.jAdjust(@$element)
      spyOn(plugin, 'init').andCallThrough()
      spyOn(plugin, 'hideImage').andCallThrough()
      expect(plugin.hideImage).toBeDefined()

      plugin.init()
      
      expect(plugin.hideImage).toHaveBeenCalled()
      expect(@$element.is(":hidden")).toBeTruthy()
      expect(plugin.adjuster instanceof Adjuster).toBeTruthy()
      expect(@$element.prop('tagName')).toBe 'IMG'

    it 'should call showImage on the image when hideImage is false', ->
      plugin = new $.jAdjust(@$element, { hideImage: false })
      spyOn(plugin, 'init').andCallThrough()
      spyOn(plugin, 'showImage').andCallThrough()
      expect(plugin.showImage).toBeDefined()

      plugin.init()
      
      expect(plugin.showImage).toHaveBeenCalled()

      plugin.showImage()

      expect(plugin.adjuster instanceof Adjuster).toBeTruthy()
      expect(@$element.prop('tagName')).toBe 'IMG'

  describe 'controls', ->
    describe 'zoom links', ->
      it 'should generate the zoom links by default', ->
        plugin = new $.jAdjust(@$element)
        expect($(".controls a.#{plugin.settings.zoomInBtnClass}")).toExist()
        expect($(".controls a.#{plugin.settings.zoomOutBtnClass}")).toExist()
        expect($(".controls a.#{plugin.settings.zoomInBtnClass}")).toHaveText $('<div />').html(plugin.settings.zoomInBtnContent).text()
        expect($(".controls a.#{plugin.settings.zoomOutBtnClass}")).toHaveText $('<div />').html(plugin.settings.zoomOutBtnContent).text()

      it 'should generate the zoom slider on request', ->
        plugin = new $.jAdjust(@$element, { zoomControlType: 'slider' })
        expect($(".controls .#{plugin.settings.zoomSliderClass}")).toExist()
        expect($(".controls .#{plugin.settings.zoomSliderClass}").slider("option", "max")).toBe plugin.settings.zoomSteps
        expect($(".controls .#{plugin.settings.zoomSliderClass}").slider("option", "min")).toBe plugin.settings.currentZoomStep
        expect($(".controls .#{plugin.settings.zoomSliderClass}").slider("option", "range")).toBe "max"
        expect($(".controls .#{plugin.settings.zoomSliderClass}").slider("option", "value")).toBe plugin.settings.currentZoomStep