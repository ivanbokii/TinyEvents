templates = $.fn.tinyEventsModules.templates

class Events
  constructor: (@element, @events) ->
    @jElement = $(@element)
    @template = _.template(templates.events)
    
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

  _initHandlers: ->
    @jElement.on('click', '.events .has-description', this._expandDescription)

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
    sortedEvents = _.sortBy(events, (e) -> e.time)

    renderedTemplate = @template(
      events: sortedEvents
    )

    $('.tiny-events .events').remove()
    $('.tiny-events').append(renderedTemplate)

  _expandDescription: ->
    # $(this).children('.description').animate(
    #   height: '80px'
    # )
    $(this).children('.description').animate(
      height: 'toggle'
      opacity: 'toggle'
    );

$.fn.tinyEventsModules.Events = Events