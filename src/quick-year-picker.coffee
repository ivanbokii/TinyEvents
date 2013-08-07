templates = $.fn.tinyEventsModules.templates

class QuickYearPicker
  #todo ivanbokii provide internalization
  YEAR_DELTA = 20
  YEARS = _.range(new Date().getFullYear() - YEAR_DELTA, new Date().getFullYear() + YEAR_DELTA)

  #shorter form for convenience
  self = QuickYearPicker

  #we don't want to open more than one picker  
  @opened = false

  @show: (event) ->
    return if self.opened
    self.callback = event.data.callback
    currentYear = event.data.currentYear()

    template = self._renderTemplate(templates.quickYearPicker, currentYear)
    template = self._setOffset(template, event.data.element)
    self._initHandlers(template)
    self._showOnScreen(template)
  
    self.opened = true

    #we need this because we need to add common handler that
    #for the calendar and will be triggered because of the 
    #bubbling
    event.stopPropagation()

  @_renderTemplate: (template, currentYear) ->
    temp = _.template(templates.quickYearPicker)
    console.log currentYear
    renderedTemplate = temp(
      years: YEARS
      current: currentYear
    )

  @_setOffset: (template, element) ->
    offset = self._getOffest(element)
    $(template).offset(offset)

  @_getOffest: (element) ->
    yearElement = $(element).find('.year')
    
    offset = yearElement.offset()
    offset.top += yearElement.height() + 10

    offset

  @_showOnScreen: (template) ->
    $(template).appendTo('body').show()
    
  @_initHandlers: (template) =>
    $(template).find('select').on('change', ->
      newYear = $(template).find('select').val()
      
      self.callback(newYear)
      self._removeQuicker(template)
    )

    $(template).on('click', (e) -> e.stopPropagation())
    $(document).on('click', ->
      self._removeQuicker(template)
    )

  @_removeQuicker: (template) ->
    $(template).remove()
    self.opened = false

$.fn.tinyEventsModules.pickers.year = QuickYearPicker 