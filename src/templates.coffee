templates = 
  calendar: "<div class='calendar'> \
              <button class='prev'>prev</button> \
              <button class='next'>next</button> \
              <h1>Year: <%= year %> </h1> \
              <h2>Month: <%= month %> </h2> \
              <h2>Day: <%= day %> </h2> \
              <ul> \
                <% _.chain(_.range(1, days + 1)).each(function(day) { %> <li> <%= day %> </li> <% }); %> \
              </ul> \
            </div>"

$.fn.tinyEventsModules.templates = templates