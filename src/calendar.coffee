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

    #set date to today
    @_switchDate(new Date)

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
    @jElement.on('click', '.days li', do =>
      self = @
      ->
        self._switchDate('Date', $(@).text())
    )

    @jElement.on('click', '.year', (event) =>
      @quickYearPicker.show(
        calendarElement: @element
        currentData: @engine.currentYear
        callback: (year) => @_switchDate('FullYear', year)
      )

      event.stopPropagation()
    )

    @jElement.on('click', '.month', (event) => 
      @quickMonthPicker.show(
        calendarElement: @element
        currentData: @engine.currentMonth
        callback: (month) => @_switchDate('Month', month)
      )

      event.stopPropagation()
    )
    #-------------------------------------------------

  _render: ->
    #todo ivanbokii optimize rendering - right
    #now the whole template rerenders on every change
    renderedTemplate = @template(
      days: @engine.daysInCurrentMonth,
      month: @engine.currentMonth, 
      year: @engine.currentYear,
      day: @engine.currentDay
    )

    #clear clendar's html and then render
    @jElement.find('.tiny-events .calendar').remove()
    @jElement.find('.tiny-events .events').before(renderedTemplate)

  #Handler. Switches date by intervals (equal one)
  #@intervalName - string, can be Date, Month, FullYear
  #@amountOfInterval is 1 by default
  _shiftDate: (intervalName, amountOfInveral) ->
    =>
      @engine.shiftDate(intervalName, amountOfInveral)
      @handlers.onDateChange(@engine.currentDate)
      @_render()

  #Handler. Changes date.
  #@intervalName - string, can be Date, Month, FullYear
  #@newDate is a new value of intervalName
  _switchDate: (intervalName, newDate) ->
    @engine.switchDate(intervalName, newDate)
    @handlers.onDateChange(@engine.currentDate)
    @_render()


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
    if Date.prototype.isPrototypeOf(intervalName)
      @currentDate = intervalName
    else
      @currentDate["set#{intervalName}"](newValue)
    
    @_initCurrentDateVariables()

$.fn.tinyEventsModules.Calendar = Calendar