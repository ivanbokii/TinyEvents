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
      @init()

    init: ->
      #todo ivanbokii combine handlers
      @_render()

      @events = new Events(@element, @options.events)

      #events handlers for calendar
      handlers = {}
      handlers.onDateChange = @events.onDateChange

      @calendar = new Calendar(@element, handlers)

    #renders template for the plugin
    _render: ->
      $(templates.tinyEvents).appendTo($(@element))

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new TinyEvents(@, options))
