utils = $.fn.tinyEventsModules.utils
templates = $.fn.tinyEventsModules.templates

class Calendar
  constructor: (@element) ->
    @engine = new CalendarEngine

    #save jQuery selector for convenience
    @jElement = $(@element)

    #precompile template
    @template = _.template(templates.calendar)
    
    #setup initial state
    @_render()
    @_initHandlers()

  _initHandlers: ->
    @jElement.on('click', 'button.next', direction: 'next', @_switchDate)
    @jElement.on('click', 'button.prev', direction: 'prev', @_switchDate)

  _render: ->
    #todo ivanbokii optimize rendering - right
    #now whole template rerenders

    renderedTemplate = @template(
      days: @engine.daysInCurrentMonth,
      month: @engine.currentMonth, 
      year: @engine.currentYear,
      day: @engine.currentDay
    )
    @jElement.html(renderedTemplate)

  _switchDate: (event) =>
    direction = event.data.direction

    if direction is 'next' then @engine.switchToNextDate() 
    else @engine.switchToPrevDate()

    @_render()

class CalendarEngine
  DAY = 24 * 60 * 60 * 1000

  constructor: ->
    @currentDate = new Date()
    @_initCurrentDateVariables()

  _initCurrentDateVariables: ->
    @currentMonth = @currentDate.getMonth() + 1
    @currentYear = @currentDate.getFullYear()
    @currentDay = @currentDate.getDate()
    @daysInCurrentMonth = utils.date.daysInMonth(@currentYear, @currentMonth)

  _dateSwitcher: (delta) ->
      @currentDate = new Date(@currentDate.getTime() + delta)
      @_initCurrentDateVariables()

  switchToNextDate: -> @_dateSwitcher(DAY)
  switchToPrevDate: -> @_dateSwitcher(-DAY)

$.fn.tinyEventsModules.Calendar = Calendar