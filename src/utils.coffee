utils = 
  date:
    daysInMonth: (year, month) ->

      # we need +1 here because months count starts from zero
      #but this code assumes that count starts from 1
      new Date(year, month + 1, 0).getDate();

$.fn.tinyEventsModules.utils = utils