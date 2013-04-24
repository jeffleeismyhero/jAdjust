#
# Name    : jAdjust
# Author  : Jeffrey Lee, frenchquarterit.com, @jeffleeismyhero
# Version : 1.0.0
# Repo    : git://github.com/jeffleeismyhero/jAdjust.git
# Website : http://jadjust.frenchquarterit.com
#

class Image
  constructor: (@element, @options) ->
    @element.css { }
    return @element

class Adjuster
  constructor: (@element, @options) ->
    @state = 'waiting'

    @size =
      height: @element.height()
      width: @element.width()

    @element.wrap("<div class='#{@options.containerClass}' style='position: relative; overflow: hidden;'/>")
    @container = @element.parent()

    @initImage()

  appendControls: ->
    @container.after("<div class='#{@options.controlsClass}' />")
    @controls = $(".#{@options.controlsClass}")
    if @options.zoomControlType == 'links'
      @controls.append(@zoomOutLink())
               .append(@zoomInLink())
    else
      @controls.append(@zoomSlider())

    @zoomInLink().on 'click', =>
      if @options.currentZoomStep < @options.zoomSteps
        @zoomIn()
      return false

    @zoomOutLink().on 'click', =>
      if @options.currentZoomStep > 1
        @zoomOut()
      return false

  zoomInLink: -> @$zoomInLink ||= $('<a />', { html: @options.zoomInBtnContent, class: @options.zoomInBtnClass, href: '#' })

  zoomOutLink: -> @$zoomOutLink ||= $('<a />', { html: @options.zoomOutBtnContent, class: @options.zoomOutBtnClass, href: '#' })

  zoomSlider: -> 
    if @options.initialZoomStep is 0
      minZoom = @options.currentZoomStep || 0
    else
      minZoom = 1

    $('<div />', { class: @options.zoomSliderClass } ).slider({
      range: 'max',
      min: minZoom,
      max: @options.zoomSteps,
      value: @options.currentZoomStep,
      slide: (ev, ui) => @calculateSliderZoom(ev, ui)
    })

  initImage: ->
    @image = new Image(@element, @options)

    @element.css({ width: @size.width, top: 0, left: 0 })

  hideImage: ->
    @image.hide()

  showImage: ->
    @image.show()

  zoomIn: ->
    if @options.currentZoomStep?
      @options.currentZoomStep += 1
    else
      @options.currentZoomStep = 1
    
    @setZoom(@options.currentZoomStep)

  zoomOut: ->
    if @options.currentZoomStep > 0
      @options.currentZoomStep -= 1
    @setZoom(@options.currentZoomStep)

  setZoom: (zoomStep) ->
    @$originalWidth ||= @image[0].width
    @$originalHeight ||= @image[0].height
    "#{(@$originalWidth / @options.zoomSteps) * zoomStep}"
    imageWidth = (@$originalWidth / @options.zoomSteps) * zoomStep
    imageHeight = (@$originalHeight / @options.zoomSteps) * zoomStep
    @image.width(imageWidth).height(imageHeight)
    @setDraggability()
    @setCoordinates([@image.width(), @image.height(), @image.position().left, @image.position().top])

  setCrop: ->
    # console.log("Setting Crop")
    # console.log("width: #{coords[0]}, height: #{coords[1]}, left: #{coords[2]}, top: #{coords[3]}")

  setDraggability: ->
    @image.draggable({ opacity: 0.45, stop: (ev, ui) => @calculateCoordinates(ev, ui) })
    @image.css({ cursor: 'move' })

  calculateCoordinates: (ev, ui) ->
    hel = ui.helper
    pos = ui.position
    top = 0
    left = 0
    # Horizontal
    h = -(hel.outerHeight() - $(hel).parent().outerHeight())
    if pos.top >= 0
      hel.animate({ top: 0 }, { duration: 100 })
      top = 0
    else if (pos.top <= h)
      hel.animate({ top: h }, { duration: 100 })
      top = h
    else
      top = pos.top
    # Vertical
    v = -(hel.outerWidth() - $(hel).parent().outerWidth())
    if pos.left >= 0
      hel.animate({ left: 0 }, { duration: 100 })
      left = 0
    else if pos.left <= v
      hel.animate({ left: v }, { duration: 100 })
      left = v
    else
      left = pos.left
    @setCoordinates([hel.width(), hel.height(), left, top])

  setCoordinates: (coords) ->
    # console.log("width: #{coords[0]}, height: #{coords[1]}, left: #{coords[2]}, top: #{coords[3]}")

  repositionImage: ->
    if @image.width() < @container.width() or @image.height() < @container.height()
      @image.animate({ left: 0, top: 0 })
    if (@container.width() - @image.width() - @image.position().left) > 0
      @image.animate({ left: 0, top: 0 })
    if (@container.height() - @image.height() - @image.position().top) > 0
      @image.animate({ left: 0, top: 0 })

  calculateSliderZoom: (ev, ui) ->
    if ui.value >= @options.currentZoomStep
      @zoomIn()
    else
      @zoomOut()
      @repositionImage()

  sizeContainer: (containerWidth, containerHeight) ->
    @container.width(containerWidth).height(containerHeight)

  sizeImage: ->
    # Automatically size image to fit
    if @options.initialZoomStep is 0 and !@options.currentZoomStep?
      loop
        break if @options.currentZoomStep? and @image.width() >= @container.width() and @image.height() >= @container.height()
        break if @options.currentZoomStep >= @options.zoomSteps
        @zoomIn()
    else
      for x in [1..@options.initialZoomStep] by 1
        @zoomIn()

$ ->
  $.jAdjust = (element, options) ->
      @defaults = {
          hideImage           : true              # boolean, hide image during load

          containerClass      : 'jAdjust'         # wrapping container class
          containerWidth      : 272               # integer, width of the container,
          containerHeight     : 300               # integer, height of the container,
          
          controlsClass       : 'controls'        # controls container class
          controlsHeight      : 26                # height of controls container
          showControls        : true              # show controls
          controlsBackground  : '#000'            # background color for the controls container
          zoomControlType     : 'links'           # control type for zoom (defaults to 'links', 'slider')
          zoomInBtnContent    : '&#43;'           # content for the zoom in button
          zoomOutBtnContent   : '&#45;'           # content for the zoom out button
          zoomInBtnClass      : 'zoom-in-button'  # class associated with the zoom in button
          zoomOutBtnClass     : 'zoom-out-button' # class associated with the zoom out button
          zoomSliderClass     : 'zoom-slider'     # class associated with the zoom slider

          zoomSteps           : 10                # number of incremental zoom steps
          initialZoomStep     : 0                 # initial zoom step (defaults to 0, which is automatic)
          
          debug               : true              # show debug data
          onLoad              : ->                # Function(image), called when the image is being loaded
          onVisible           : ->                # Function(image), called when the image is loaded
          onReady             : ->                # Function(image), called when the jAdjust is ready
      }

      # plugin settings
      @settings = {}

      # jQuery version of DOM element attached to the plugin
      @$element = $ element

      # Adjuster object
      @adjuster = {}

      ## public methods

      # get particular plugin setting
      @getSetting = (settingKey) ->
        @settings[settingKey]

      # call one of the plugin setting functions
      @callSettingFunction = (functionName) ->
        @settings[functionName]()

      @settings = $.extend {}, @defaults, options
      @adjuster = new Adjuster(@$element, @settings)

      @hideImage = ->
        @adjuster.hideImage()

      @showImage = ->
        @adjuster.showImage()

      # init function
      @init = ->
        @callSettingFunction 'onLoad'
        @hideImage() if @getSetting 'hideImage'

        if width = @getSetting 'containerWidth'
          if height = @getSetting 'containerHeight'
            @adjuster.sizeContainer(width, height)
            @adjuster.sizeImage()

        @adjuster.appendControls() if @getSetting 'showControls'

        @callSettingFunction 'onReady'
        @showImage()

      # Initialize the plugin
      @init()

      this

    $.fn.jAdjust = (options) ->
        return this.each ->
            if undefined == $(this).data 'jAdjust'
              plugin = new $.jAdjust this, options
              $(this).data 'jAdjust', plugin
