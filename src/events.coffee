templates = $.fn.tinyEventsModules.templates

class Events
  constructor: (@element, @events) ->
    @engine = new EventsEngine()
    @jElement = $(@element)
    @template = _.template(templates.events)
    
    #continue-> group events by dates
    @_groupEvents()

    @_render()
    @_initHandlers()

  #---events handlers----------------
  onDateChange: (newDate) ->
    console.log newDate
  #----------------------------------

  _groupEvents: ->
    @groupedEvents = _.chain(@events)
      .map((e) -> 
        time = new Date(e.time)
        e.month = time.getMonth()
        e.year = time.getFullYear()

        e)
      .groupBy((e) -> "#{e.year}/#{e.month}")
      .value()

  _render: ->
    #you need to check dates - whether they are js dates or some other format
    #probably json
    renderedTemplate = @template(
      events: @events
    )

    @jElement.find('.tiny-events .events').remove()
    @jElement.find('.tiny-events .calendar').after(renderedTemplate)
  
  _initHandlers: ->

class EventsEngine

$.fn.tinyEventsModules.Events = Events