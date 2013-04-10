#
# Name    : jAdjust
# Author  : Jeffrey Lee, frenchquarterit.com, @jeffleeismyhero
# Version : 1.0.0
# Repo    : git://github.com/jeffleeismyhero/jAdjust.git
# Website : http://jadjust.frenchquarterit.com
#

$ ->
    $.jAdjust = (element, options) ->
        @defaults = {
            width               : 272        # integer, width of the container and image,
            height              : 300        # integer, height of the container and image,
            show                : false      # boolean, show on load
     
            time                : 4000       # animation time
            showSpeed           : 600        # number, animation showing speed in milliseconds
                 
            showEasing          : ''         # string, easing equation on load, must load http:#gsgd.co.uk/sandbox/jquery/easing/
            hideEasing          : ''         # string, easing equation on hide, must load http:#gsgd.co.uk/sandbox/jquery/easing/
     
            containerClass      : 'jAdjust'  # wrapping container class
            controlsClass       : 'controls' # controls container class
            controlsHeight      : 26         # height of controls container
            controlsBackground  : '#000'     # background color for the controls container
     
            debug               : true       # show debug data
            onLoad              : ->         # Function(image), called when the image is being loaded
            onVisible           : ->         # Function(image), called when the image is loaded
        }

        # current state of the adjustment
        state = ''

        # adjustment settings
        @settings = {}

        # adjustment element
        @$element = $ element

        #
        # private methods
        #
        setState = (_state) ->
          state = _state
  
        wrapElement = =>
          @$elementContainer = $('<div />', { 'class' : (@getSetting 'containerClass') })
          @$element.wrap @$elementContainer

        sizeElementAndContainer = =>
          @$elementContainer = @$element.parent()
          @$elementContainer.width(@getSetting 'width')
          @$elementContainer.height((@getSetting 'height') + (@getSetting 'controlsHeight'))
          @$element.width(@getSetting 'width')
          @$element.height(@getSetting 'height')

        addControls = =>
          @$element.css({display: 'block'})
          @$elementContainer.append(
            $('<div />', { 'class' : (@getSetting 'controlsClass') })
              .css({
                background: (@getSetting 'controlsBackground'),
                height: (@getSetting 'controlsHeight')
              })
          )
            
        addDebugData = =>
          @$elementContainer.after(
            $('<div />', { 'class' : 'jAdjust-debug' })
              .css({
                background: '#CCC',
                height: '200px',
                width: @getSetting('width'),
                float: 'left',
                clear: 'both',
                display: 'block'
              })
          )

        #
        # public methods
        #
        @getState = ->
          state

        @getSetting = (settingKey) ->
          @settings[settingKey]

        @callSettingFunction = (functionName) ->
          @settings[functionName](element)

        @init = ->
            setState 'hidden'
            @settings = $.extend {}, @defaults, options

            if (@getSetting 'show') is true
              @$element.show()
              setState 'visible'
            else
              # set css properties
              @$element.hide()

            # Check the existence of the element
            if @$element.length

              # wrap the notification content for easier styling
              wrapElement()

              # set the size of the element and its container
              sizeElementAndContainer()

              # add controls
              addControls()

              if (@getSetting 'debug') is true
                addDebugData()

              @showElement() if @getState() isnt 'showing' and @getState() isnt 'visible'

        # Show image
        @showElement = ->
          if @getState() isnt 'showing' and @getState() isnt 'visible'
            setState 'showing'
            @callSettingFunction 'onLoad'
            @$element.fadeIn((@getSetting 'showSpeed'), (@getSetting 'showEasing'), =>
              setState 'visible'
              @callSettingFunction 'onVisible'
            )

        # Initialize the image
        @init()

        this

    $.fn.jAdjust = (options) ->
        return this.each ->
            # Make sure jAdjust hasn't been already attached to the element
            plugin = ($ this).data('jAdjust')
            if plugin == undefined
                plugin = new $.jAdjust this, options
                ($ this).data 'jAdjust', plugin
            else
                plugin.show()
