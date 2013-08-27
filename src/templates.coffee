templates = 
  tinyEvents: "<div class='tiny-events'></div>"

  calendar: "<div class='calendar'> \
                <button class='prev-month'>prev month</button> \
                <button class='next-month'>next month</button> \

                <button class='prev-year'>prev year</button> \
                <button class='next-year'>next year</button> \
                
                <h1 class='year'>Year: <%= year %> </h1> \
                <h2 class='month'>Month: <%= month %> </h2> \
                <h2>Day: <%= day %> </h2> \
                <ul class='days'> \
                  <% _.chain(_.range(1, days + 1)).each(function(day) { %> <li> <%= day %> </li> <% }); %> \
                </ul> \
              </div>"

  events: "<div class='events'> \
            <button class='title'>title</button> \
            <button class='time'>time</button> \

            <ul> \
              <% _.each(events, function(e) { %> \
                <li> \
                  <%= e.title %> \
                  <p> \
                    <%= e.description %> \
                  </p> \
                  <% var tempTime = new Date(e.time) %> \
                  <%= tempTime.getHours() %>:<%= tempTime.getMinutes() %> \
                </li> \
              <% }) %> \
            </ul> \
          </div>"

  quickMonthPicker: "<div class='quick-month-picker'> \
                      <select> \
                        <% _.each(data, function(m, i) { %> \
                          <% if(i+1 == current) { %> \
                            <option selected='selected' value='<%= i %>'><%= m %> </option> \
                          <% } else { %> \
                            <option value='<%= i %>'><%= m %> </option> \
                          <% } %> \
                        <% }) %> \
                      </select> \
                    </div>"

  quickYearPicker: "<div class='quick-year-picker'> \
                      <select> \
                        <% _.each(data, function(m) { %> \
                          <% if(m == current) { %> \
                            <option selected='selected'><%= m %> </option> \
                          <% } else { %> \
                            <option><%= m %> </option> \
                          <% } %> \
                        <% }) %> \
                      </select> \
                    </div>"

$.fn.tinyEventsModules.templates = templates