templates = $.fn.tinyEventsModules.templates
utils = $.fn.tinyEventsModules.utils

class Events
  animationSpeed = 200

  constructor: (@element, @events, @handlers) ->
    @template = _.template(templates.events)

    @_groupEvents()
    @_initHandlers()
    @_subsribeToEvents()

  #---public api----------------------------------------------------------------
  getDateEvents: (date) ->
    @_findDateEvents(date)

  getAllEvents: ->
    @groupedEvents

  addEvent: (event) ->
    @events.push(event)
    @_groupEvents()

    #check whether event is for the current date and if yes - rerender events
    #panel
    currentKey = utils.date.getKey(@currentDate)
    eventKey = utils.date.getKey(event.time)

    if currentKey is eventKey
      @_render(@_findDateEvents(@currentDate))

    @handlers.run('onEventsAdd', event)

  removeEvent: (event) ->
    _.each(_.keys(@groupedEvents), (key) =>
      if _.contains(@groupedEvents[key], event)
        @groupedEvents[key] = _.without(@groupedEvents[key], event)

        #check whether event is for the current date and if yes - rerender events
        #panel
        currentKey = utils.date.getKey(@currentDate)
        eventKey = utils.date.getKey(new Date(event.time))

        if currentKey is eventKey then @_render(@_findDateEvents(@currentDate))
        @handlers.run('onEventsRemove', {event: event, length: @groupedEvents[key].length})
    )
  #-----------------------------------------------------------------------------

  #---events handlers----------------
  _findDateEvents: (date) ->
    key = utils.date.getKey(date)
    @groupedEvents[key]

  _initHandlers: ->
    @element.on('click', '.events .has-description .event-control', @._expandDescription)

  _subsribeToEvents: ->
    @handlers.add('onDateChange', @_onDateChange)

  _onDateChange: (newDate) =>
    @currentDate = newDate
    dateEvents = @_findDateEvents(newDate)
    @_render(dateEvents)
    @currentDate = newDate
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

    #add zero to the beginning because otherwise 00 would be 0
    hours = (e) ->
      tmp = (new Date(e.time)).getHours()
      if tmp < 10 then "0" + tmp.toString() else tmp

    #add zero to the beginning because otherwise 00 would be 0
    minutes = (e) ->
      tmp = (new Date(e.time)).getMinutes()
      if tmp < 10 then "0" + tmp.toString() else tmp

    _.each(events, (e) -> e.formattedTime = "#{hours(e)}:#{minutes(e)}");

    renderedTemplate = @template(
      events: sortedEvents
    )

    $('.tiny-events .events').empty()

    renderedTemplate = $(renderedTemplate).hide()
    $('.tiny-events .events').append(renderedTemplate)
    $(renderedTemplate).fadeIn(animationSpeed)

    $('.events div').last().addClass('last')

  _expandDescription: ->
    eventControl = $(@).parent().find('.event-control')
    if eventControl.hasClass('expand')
      eventControl.hide();
      eventControl.removeClass('expand').addClass('collapse')
      eventControl.attr('src', 'images/collapse.png')
      eventControl.fadeIn(200);
    else
      eventControl.hide();
      eventControl.removeClass('collapse').addClass('expand')
      eventControl.attr('src', 'images/expand.png')
      eventControl.fadeIn(200);

    $(@).parent().find('.description').animate(
      height: 'toggle'
      opacity: 'toggle',
    animationSpeed)

$.fn.tinyEventsModules.Events = Events