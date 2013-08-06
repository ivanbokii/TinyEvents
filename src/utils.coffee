utils = 
  date:
    daysInMonth: (year, month) ->
      new Date(year, month, 0).getDate();

$.fn.tinyEventsModules.utils = utils