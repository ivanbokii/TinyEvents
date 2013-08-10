class QuickPicker
  constructor: ->
    #indicates whether picker is open or closed
    @opened = false

  show: (data) ->
    return if @opened

    renderedTemplate = @_renderTemplate(@template, data.currentData)
    renderedTemplate = @_setUIOffset(renderedTemplate, data.calendarElement)

    @_initHandlers(renderedTemplate, data.callback)
    @_showOnScreen(renderedTemplate)

    @opened = true

  _renderTemplate: (template, currentData) ->
    temp = _.template(template)
    renderedTemplate = temp(
      data: @templateConstants
      current: currentData
    )

  _setUIOffset: (template, calendarElement) ->
    offset = @_getUIOffest(calendarElement)
    $(template).offset(offset)

  _getUIOffest: (calendarElement) ->
    triggerElement = $(calendarElement).find(@triggerElementClassName)
    
    offset = triggerElement.offset()
    offset.top += triggerElement.height() + 10

    offset

  _showOnScreen: (template) ->
    $(template).appendTo('body').show()

  _initHandlers: (template, callback) ->
    $(template).find('select').on('change', =>
      newValue = $(template).find('select').val()
      
      callback(newValue)
      @_removeQuicker(template)
    )

    #click on anything except quick picker and it should close
    $(template).on('click', (e) -> e.stopPropagation())
    $(document).on('click', =>
      @_removeQuicker(template)
    )

  _removeQuicker: (template) ->
    $(template).remove()
    @opened = false

$.fn.tinyEventsModules.pickers.QuickPicker = QuickPicker