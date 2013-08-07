utils = $.fn.tinyEventsModules.utils
templates = $.fn.tinyEventsModules.templates
pickers = $.fn.tinyEventsModules.pickers

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
    @jElement.on('click', 'button.next-month', direction: 'next', 
      @_shiftDate('Month', 1))
    @jElement.on('click', 'button.prev-month', direction: 'prev', 
      @_shiftDate('Month', -1))

    @jElement.on('click', 'button.next-year', direction: 'next', 
      @_shiftDate('FullYear', 1))
    @jElement.on('click', 'button.prev-year', direction: 'prev', 
      @_shiftDate('FullYear', -1))

    @jElement.on('click', '.days li', @_switchDate())
    @jElement.on('click', '.year', 
      {
        element: @element
        #need to use function because during handler init
        #it catches current month value and
        #uses it on every call
        currentYear: => @engine.currentYear
        callback: @_switchYear
      }, pickers.year.show)

    @jElement.on('click', '.month', 
      {
        element: @element
        #need to use function because during handler init
        #it catches current month value and
        #uses it on every call
        currentMonth: => @engine.currentMonth
        callback: @_switchMonth
      }, pickers.month.show)

  _render: ->
    #todo ivanbokii optimize rendering - right
    #now the whole template rerenders
    renderedTemplate = @template(
      days: @engine.daysInCurrentMonth,
      month: @engine.currentMonth, 
      year: @engine.currentYear,
      day: @engine.currentDay
    )
    @jElement.html(renderedTemplate)

  _shiftDate: (intervalName, amountOfInveral) ->
    =>
      @engine.shiftDate(intervalName, amountOfInveral)
      @_render()

  _switchDate: ->
    self = @
    ->
      day = parseInt($(@).text())
      self.engine.switchDay(day)
      self._render()

  _switchMonth: (month) =>
    @engine.switchMonth(month)
    @._render()

  _switchYear: (year) =>
    @engine.switchYear(year)
    @._render()

  _showQuickYearPicker: ->
    alert('fuck')

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

  switchDay: (day) ->
    @currentDate.setDate(day)
    @_initCurrentDateVariables()

  switchMonth: (month) ->
    @currentDate.setMonth(month)
    @_initCurrentDateVariables()

  switchYear: (year) ->
    @currentDate.setFullYear(year)
    @_initCurrentDateVariables()

$.fn.tinyEventsModules.Calendar = Calendar