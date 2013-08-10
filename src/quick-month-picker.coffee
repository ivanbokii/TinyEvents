templates = $.fn.tinyEventsModules.templates
QuickPicker = $.fn.tinyEventsModules.pickers.QuickPicker

class QuickMonthPicker extends QuickPicker
  #todo ivanbokii provide internalization
  MONTHS = ["January", "February", "March", "April", "May",
    "June", "July", "August", "September", "October", "November", "December"]

  constructor: ->
    @template = templates.quickMonthPicker
    @templateConstants = MONTHS
    @triggerElementClassName = '.month'

$.fn.tinyEventsModules.pickers.Month = QuickMonthPicker 