utils = $.fn.tinyEventsModules.utils
templates = $.fn.tinyEventsModules.templates
pickers = $.fn.tinyEventsModules.pickers

class Calendar
  constructor: (@element, @handlers) ->
    @engine = new CalendarEngine
    @quickMonthPicker = new pickers.Month()
    @quickYearPicker = new pickers.Year()

    #save jQuery selector for convenience
    @jElement = $(@element)

    #precompile template
    @template = _.template(templates.calendar)
    
    #setup initial state
    @_render()
    @_initHandlers()

    #this line should be removed as a result of refactoring
    @handlers.onDateChange(@engine.currentDate)

  _initHandlers: ->
    #---shift date-----------------------------------
    @jElement.on('click', 'button.next-month', direction: 'next', 
      @_shiftDate('Month', 1))
    @jElement.on('click', 'button.prev-month', direction: 'prev', 
      @_shiftDate('Month', -1))

    @jElement.on('click', 'button.next-year', direction: 'next', 
      @_shiftDate('FullYear', 1))
    @jElement.on('click', 'button.prev-year', direction: 'prev', 
      @_shiftDate('FullYear', -1))

    #---switch date-----------------------------------
    @jElement.on('click', '.days li', ->
      self = @
      ->
        self.switchDate('Date', $(@.text()))
    )

    @jElement.on('click', '.days li', @_switchDate())
    @jElement.on('click', '.year', (event) =>
      @quickYearPicker.show(
        calendarElement: @element
        currentData: @engine.currentYear
        callback: @_switchYear
      )

      event.stopPropagation()
    )

    @jElement.on('click', '.month', (event) => 
      @quickMonthPicker.show(
        calendarElement: @element
        currentData: @engine.currentMonth
        callback: @_switchMonth
      )

      event.stopPropagation()
    )

  _render: ->
    #todo ivanbokii optimize rendering - right
    #now the whole template rerenders on every change
    renderedTemplate = @template(
      days: @engine.daysInCurrentMonth,
      month: @engine.currentMonth, 
      year: @engine.currentYear,
      day: @engine.currentDay
    )

    @jElement.find('.tiny-events .calendar').remove()
    @jElement.find('.tiny-events').append(renderedTemplate)

  _shiftDate: (intervalName, amountOfInveral) ->
    =>
      @engine.shiftDate(intervalName, amountOfInveral)
      @handlers.onDateChange(@engine.currentDate)
      @_render()

  _switchDate: ->
    self = @
    ->
      day = parseInt($(@).text())
      self.engine.switchDay(day)
      self.handlers.onDateChange(self.engine.currentDate)
      self._render()

  _switchMonth: (month) =>
    @engine.switchMonth(month)
    @handlers.onDateChange(@engine.currentDate)
    @._render()

  _switchYear: (year) =>
    @engine.switchYear(year)
    @handlers.onDateChange(@engine.currentDate)
    @._render()

class CalendarEngine
  constructor: ->
    @currentDate = new Date()
    @_initCurrentDateVariables()
    
    window.engine = @

  _initCurrentDateVariables: ->
    #add one because months starts with 0
    @currentMonth = @currentDate.getMonth() + 1
    @currentYear = @currentDate.getFullYear()
    @currentDay = @currentDate.getDate()
    @daysInCurrentMonth = utils.date.daysInMonth(@currentYear, @currentMonth)

  #interval name can be date, month, year
  shiftDate: (intervalName, amountOfTime) ->
    @currentDate["set#{intervalName}"](
      @currentDate["get#{intervalName}"]() + amountOfTime)
    
    @_initCurrentDateVariables()

  switchDate: (intervalName, newValue) ->
    @currentDate["set#{intervalName}"](newValue)

  # switchDay: (day) ->
  #   @currentDate.setDate(day)
  #   @_initCurrentDateVariables()

  # switchMonth: (month) ->
  #   @currentDate.setMonth(month)
  #   @_initCurrentDateVariables()

  # switchYear: (year) ->
  #   @currentDate.setFullYear(year)
  #   @_initCurrentDateVariables()

$.fn.tinyEventsModules.Calendar = Calendar