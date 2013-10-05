utils = $.fn.tinyEventsModules.utils
templates = $.fn.tinyEventsModules.templates

class Calendar
  monthNames = [ "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December" ]
  weekDaysNames = [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
      "Saturday" ]
  animationSpeed = 200

  constructor: (@element, @events, @handlers) ->
    @engine = new CalendarEngine

    @_initialRender()
    @_initActionsHandlers()
    @handlers.run('onDateChange', @engine.currentDate)

  #---public api----------------------------------------------------------------
  getSelectedDate: ->
    @engine.currentDate

  resetEvents: (events) ->
    @events = events
    @_renderMonthDates()
  #-----------------------------------------------------------------------------

  _initialRender: ->
    @_renderCalendar()
    @_renderYear()
    @_renderDateAndDay()
    @_renderMonth()
    @_renderMonthDates()

  _renderCalendar: ->
    template = _.template(templates.calendar)
    @element.find('.calendar').append(template())

  _renderYear: ->
    year = @engine.currentYear

    #here animation will go
    @element.find('.year span').hide()
    @element.find('.year span').text(year).fadeIn(animationSpeed)

  _renderDateAndDay: ->
    day = @engine.currentDay

    #here animation will go
    @element.find('.date').hide()
    @element.find('.weekday').hide()

    @element.find('.date').text(day).fadeIn(animationSpeed)
    @element.find('.weekday').text(weekDaysNames[@engine.currentWeekDay]).fadeIn(animationSpeed)

  _renderMonth: ->
    month = monthNames[@engine.currentMonth]

    #here animation will go
    @element.find('.month span').hide()
    @element.find('.month span').text(month).fadeIn(animationSpeed)

  _renderMonthDates: ->
    days = @engine.daysInCurrentMonth
    currentDay = @engine.currentDay
    template = _.template(templates.monthDates)

    #here we need to mark dates that have events
    dates = _.chain(@events)
    .pluck('time')
    .map((t) -> new Date(t))
    .filter((t) => t.getFullYear() is @engine.currentYear and t.getMonth() is @engine.currentMonth)
    .map((t) -> t.getDate())
    .uniq()
    .value()
    #-------------------------------------------

    #here animation will go
    @element.find('.month + table').remove()

    renderedTemplate = $(template(days: days, current: currentDay, eventDates: dates)).hide()
    @element.find('.month').after(renderedTemplate)
    renderedTemplate.fadeIn()

  _initActionsHandlers: ->
    @element.on('click', '.month img.next', 'next', @_switchMonth)
    @element.on('click', '.month img.prev', 'prev', @_switchMonth)
    @element.on('click', '.year img.next', 'next', @_switchYear)
    @element.on('click', '.year img.prev', 'prev', @_switchYear)
    @element.on('click', '.all table td', @_switchDate)

    @handlers.add('onEventsAdd', @_addEvents)
    @handlers.add('onEventsRemove', @_removeEvents)

  _addEvents: (events) =>
    @events = @events.concat(events)
    @_renderMonthDates()

  #find events in inner collection that should
  #be removed and redraw months dates to update marks
  _removeEvents: (events) =>
    titlesToRemove = _.pluck(events, 'title')

    eventsToRemove = _.filter(@events, (event) ->
      _.contains(titlesToRemove, event.title)
    )

    #because of the special way _.without should be called we need
    #to construct args before the actual call
    args = [@events].concat(eventsToRemove)
    @events = _.without.apply(_, args)
    @_renderMonthDates()

  _switchMonth: (e) =>
    direction = if e.data is 'next' then 1 else -1

    @engine.shiftDate('Month', direction)

    @_renderYear() if @engine.yearChanged
    @_renderMonth()
    @_renderMonthDates()
    @_renderDateAndDay() if @engine.dayChanged or @engine.currentWeekDayChange

    @handlers.run('onDateChange', @engine.currentDate)
    @handlers.run('onMonthChange', @engine.currentMonth)

  _switchYear: (e) =>
    direction = if e.data is 'next' then 1 else -1

    @engine.shiftDate('FullYear', direction)
    @_renderYear()
    @_renderMonth() if @engine.monthChanged
    @_renderMonthDates()
    @_renderDateAndDay() if @engine.dayChanged or @engine.currentWeekDayChange

    @handlers.run('onDateChange', @engine.currentDate)
    @handlers.run('onYearChange', @engine.currentYear)

  _switchDate: (e) =>
    date = $(e.target).text()

    @engine.switchDate('Date', date)

    #highlight a current selected date
    @element.find('td').removeClass('currentDate')
    $(e.target).addClass('currentDate')

    @_renderDateAndDay()

    @handlers.run('onDateChange', @engine.currentDate)
    @handlers.run('onDayChange', @engine.currentWeekDay)

class CalendarEngine
  constructor: ->
    @currentDate = new Date()
    @_initCurrentDateVariables()
    window.currentDate = @currentDate

  _initCurrentDateVariables: ->
    @monthChanged = @currentMonth isnt @currentDate.getMonth()
    @currentMonth = @currentDate.getMonth()

    @yearChanged = @currentYear isnt @currentDate.getFullYear()
    @currentYear = @currentDate.getFullYear()

    @dayChanged = @currentDay isnt @currentDate.getDate()
    @currentDay = @currentDate.getDate()

    @currentWeekDayChange = @currentWeekDay isnt @currentDate.getDay()
    @currentWeekDay = @currentDate.getDay()

    @daysInMonthChanged = @daysInCurrentMonth isnt utils.date.daysInMonth(@currentYear, @currentMonth)
    @daysInCurrentMonth = utils.date.daysInMonth(@currentYear, @currentMonth)

  #interval name can be date, month, year
  shiftDate: (intervalName, amountOfTime) ->

    #small hack to make dates switching behave correct during month switch------
    #in this case we switch to closest biggest existing month' date
    if intervalName is 'Month'
      currentDate = @currentDate.getDate()
      monthToSwitch = @currentDate.getMonth() + amountOfTime
      tempDate = new Date(@currentDate.getFullYear(), monthToSwitch)
      daysInMonth = utils.date.daysInMonth(tempDate.getFullYear(), tempDate.getMonth())

      if currentDate > daysInMonth then @currentDate.setDate(daysInMonth)
    #---------------------------------------------------------------------------

    @currentDate["set#{intervalName}"](@currentDate["get#{intervalName}"]() + amountOfTime)

    @_initCurrentDateVariables()

  switchDate: (intervalName, newValue) ->
    if Date.prototype.isPrototypeOf(intervalName)
      @currentDate = intervalName
    else
      @currentDate["set#{intervalName}"](newValue)

    @_initCurrentDateVariables()

$.fn.tinyEventsModules.Calendar = Calendar