templates = $.fn.tinyEventsModules.templates

class QuickMonthPicker
  #todo ivanbokii provide internalization
  MONTHS = ["January", "February", "March", "April", "May",
    "June", "July", "August", "September", "October", "November", "December"]

  #shorter form for convenience
  self = QuickMonthPicker

  #we don't want to open more than one month picker  
  @opened = false

  @show: (event) ->
    return if self.opened
    self.callback = event.data.callback
    currentMonth = event.data.currentMonth()

    template = self._renderTemplate(templates.quickMonthPicker, currentMonth)
    template = self._setOffset(template, event.data.element)
    self._initHandlers(template)
    self._showOnScreen(template)
  
    self.opened = true

    #we need this because we need to add common handler that
    #for the calendar and will be triggered because of the 
    #bubbling
    event.stopPropagation()

  @_renderTemplate: (template, currentMonth) ->
    temp = _.template(templates.quickMonthPicker)
    console.log currentMonth
    renderedTemplate = temp(
      months: MONTHS
      current: currentMonth
    )

  @_setOffset: (template, element) ->
    offset = self._getOffest(element)
    $(template).offset(offset)

  @_getOffest: (element) ->
    monthElement = $(element).find('.month')
    
    offset = monthElement.offset()
    offset.top += monthElement.height() + 10

    offset

  @_showOnScreen: (template) ->
    $(template).appendTo('body').show()
    
  @_initHandlers: (template) =>
    $(template).find('select').on('change', ->
      newMonth = $(template).find('select').val()
      
      self.callback(newMonth)
      self._removeQuicker(template)
    )

    $(template).on('click', (e) -> e.stopPropagation())
    $(document).on('click', ->
      self._removeQuicker(template)
    )

  @_removeQuicker: (template) ->
    $(template).remove()
    self.opened = false

$.fn.tinyEventsModules.pickers.month = QuickMonthPicker 
  
