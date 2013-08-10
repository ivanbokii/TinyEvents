templates = $.fn.tinyEventsModules.templates
QuickPicker = $.fn.tinyEventsModules.pickers.QuickPicker

class QuickYearPicker extends QuickPicker
  #todo ivanbokii provide internalization
  YEAR_DELTA = 20
  YEARS = _.range(new Date().getFullYear() - YEAR_DELTA, new Date().getFullYear() + YEAR_DELTA)

  constructor: ->
    @template = templates.quickYearPicker
    @templateConstants = YEARS
    @triggerElementClassName = '.year'

$.fn.tinyEventsModules.pickers.Year = QuickYearPicker