describe 'jAdjust', ->
  options =
    initialZoom: 2
    containerWidth: 272
    containerHeight: 300

  beforeEach ->
    loadFixtures 'fragment.html'
    @$element = $( '#fixtures' )

  describe 'plugin behavior', ->
    it 'should be available on the jQuery object', ->
      expect( $.fn.jAdjust ).toBeDefined()

    it 'should be chainable', ->
      expect( @$element.jAdjust() ).toBe @$element

    it 'should offers default values', ->
      plugin = new $.jAdjust( @$element )

      expect( plugin.defaults ).toBeDefined()

    it 'should overwrites the settings', ->
      plugin = new $.jAdjust( @$element, options )

      expect( plugin.settings.message ).toBe( options.message )

  describe 'plugin state', ->
    beforeEach ->
      @plugin = new $.jAdjust( @$element )

    it 'should have a ready state', ->
      expect( @plugin.getState() ).toBe 'ready'

    it 'should be updatable', ->
      @plugin.setState( 'new state' )

      expect( @plugin.getState() ).toBe 'new state'