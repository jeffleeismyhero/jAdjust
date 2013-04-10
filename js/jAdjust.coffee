#
# Name    : jAdjust
# Author  : Jeffrey Lee, frenchquarterit.com, @jeffleeismyhero
# Version : 1.0.0
# Repo    : git://github.com/jeffleeismyhero/jAdjust.git
# Website : http://jadjust.frenchquarterit.com
#

jQuery ->
  $.jAdjust = ( element, options ) ->
    # current state
    state = ''

    # plugin settings
    @settings = {}

    # jQuery version of DOM element attached to the plugin
    @$element = $ element

    # set current state
    @setState = ( _state ) -> state = _state

    #get current state
    @getState = -> state

    # get particular plugin setting
    @getSetting = ( key ) ->
      @settings[ key ]

    # call one of the plugin setting functions
    @callSettingFunction = ( name, args = [] ) ->
      @settings[name].apply( this, args )

    @init = ->
      @settings = $.extend( {}, @defaults, options )

      @setState 'ready'

    # initialise the plugin
    @init()

    # make the plugin chainable
    this

  # default plugin settings
  $.jAdjust::defaults =
      initialZoom: 2 # initial image zoom (1-10)
      containerWidth: 272
      containerHeight: 300

  $.fn.jAdjust = ( options ) ->
    this.each ->
      if $( this ).data( 'jAdjust' ) is undefined
        plugin = new $.jAdjust( this, options )
        $( this).data( 'jAdjust', plugin )