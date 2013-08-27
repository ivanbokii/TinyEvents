templates = $.fn.tinyEventsModules.templates

class Events
  constructor: (@element, @events) ->
    @engine = new EventsEngine()
    @jElement = $(@element)
    @template = _.template(templates.events)

    #by default sort events by time
    @sortBy = 'time'
    
    @_groupEvents()
    @_initHandlers()

  #---events handlers----------------
  onDateChange: (newDate) =>
    @currentDate = newDate
    dateEvents = @_findDateEvents(newDate)
    @_render(dateEvents)

  _findDateEvents: (date) ->
    dateKey = "#{date.getDate()}/#{date.getMonth()}/#{date.getFullYear()}"
    @groupedEvents[dateKey]

  #----------------------------------

  _groupEvents: ->
    @groupedEvents = _.chain(@events)
      .map((e) -> 
        time = new Date(e.time)
        e.day = time.getDate()
        e.month = time.getMonth()
        e.year = time.getFullYear()

        e)
      .groupBy((e) -> "#{e.day}/#{e.month}/#{e.year}")
      .value()

  _render: (events) ->
    sortedEvents = @_sort(events)

    renderedTemplate = @template(
      events: sortedEvents
    )

    $('.tiny-events .events').remove()
    $('.tiny-events').append(renderedTemplate)

  _rerender: ->
    @onDateChange(@currentDate)

  _sort: (events) ->
    if @sortBy is 'time'
      _.sortBy(events, (e) -> e.time)
    else
      _.sortBy(events, (e) -> e.title)
  
  _initHandlers: ->
    @jElement.on('click', '.events .title', => 
      @sortBy = 'title'
      @_rerender()
    )
    @jElement.on('click', '.events .time', => 
      @sortBy = 'time'
      @_rerender()
    )

class EventsEngine

$.fn.tinyEventsModules.Events = Events