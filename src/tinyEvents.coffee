# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.

do ($ = jQuery, window, document) ->
  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "tinyEvents"
  defaults =
    property: "value"

  Calendar = $.fn.tinyEventsModules.Calendar
  Events = $.fn.tinyEventsModules.Events
  templates = $.fn.tinyEventsModules.templates

  # The actual plugin constructor
  class TinyEvents
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @_init()

    _init: ->
      #todo ivanbokii combine handlers
      @_render()

      #events handlers for calendar
      @_initHandlers()
      @handlers.run('onInit')

      container = $(@element).find('.tiny-events')
      @events = new Events(container, @options.events, @handlers)
      @calendar = new Calendar(container, @options.events, @handlers)

      @handlers.run('onInitComplete')
      $(@element).data('tinyEvents', @)

    #renders carcass for the calendar
    _render: ->
      $(templates.tinyEvents).appendTo($(@element))

    _initHandlers: ->
      @handlers =
        events:
          onDateChange: [@options.handlers.onDateChange]
          onDayChange: [@options.handlers.onDayChange]
          onMonthChange: [@options.handlers.onMonthChange]
          onYearChange: [@options.handlers.onYearChange]
          onInit: [@options.handlers.onInit]
          onInitComplete: [@options.handlers.onInitComplete]
          onEventsAdd: []
          onEventsRemove: []
        ,
        add: (name, handler) ->
          unless _.isUndefined(name) then @events[name].push handler
        ,
        remove: (name, handler) ->
          @events[name] = _.without(@events[name], handler)
        ,
        run: (name, params) ->
          @events[name] = _.compact(@events[name])
          _.each(@events[name], (e) -> e(params))

  #----public api---------------------------------------------------------------
    getSelectedDate: ->
      @calendar.getCurrentDate()

    getDateEvents: (date) ->
      @events.getDateEvents(date)

    getAllEvents: ->
      @events.getAllEvents()

    addEvent: (event) ->
      @events.addEvent(event)

    removeEvent: (event) ->
      @events.removeEvent(event)
  #-----------------------------------------------------------------------------

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new TinyEvents(@, options))
