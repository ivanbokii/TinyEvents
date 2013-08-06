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

  # The actual plugin constructor
  class TinyEvents
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      #init calendar engine here
      @calendar = new Calendar(@element)

    _switchDate: (event) =>
      #get current date
      #check if current date is the end of the month
      #if no -> change current date to the new one
      #if yes -> check that current month is the last one
      #if no -> change month and set current date to the first date
      #if yes -> change year, month and date


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new TinyEvents(@, options))
