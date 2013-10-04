templates =
  tinyEvents: "<div class='tiny-events'> \
                <div class='calendar'> \
                </div> \
                <div class='events'> \
                </div> \
              </div>"

  calendar: "  <div class='current'> \
                  <div class='year'> \
                    <img class='prev' src='images/blue_left.png'> \
                    <span></span> \
                    <img class='next' src='images/blue_right.png'> \
                  </div> \

                  <span class='date'></span> \
                  <br>
                  <span class='weekday'></span> \
                </div> \

                <div class='all'> \
                  <div class='month'> \
                    <img class='prev' src='images/white_left.png'> \
                    <span></span> \
                    <img class='next' src='images/white_right.png'> \
                  </div> \
                </div>"

  monthDates: "<table> \
                <% for (var i = 1; i <= days; i++) { %> \
                  <% if ((i - 1) % 7 === 0) { %> \
                    <tr> \
                  <% } %> \

                  <% \
                    var styleClass = ''; \
                    if (i === current) styleClass += 'currentDate '; \
                    if (eventDates.indexOf(i) !== -1) styleClass += 'hasEvents '; \
                   %> \
                  <td class='<%= styleClass %>'>  <%= i %> </td> \

                  <% if (i % 7 === 0) { %> \
                    </tr> \
                  <% } %> \
                <% } %> \
              </table>"

  events: "<% events.forEach(function (event) { %> \
              <div <% if (event.description !== undefined) { %> class='has-description' <% } %> > \
                <% if (event.description !== undefined) { %> <img class='event-control expand' src='images/expand.png' ><% } %>

                <span class='time'><%= event.formattedTime %></span> \
                <p class='title'> <%= event.title %> </p> \
                <p class='description'> \
                  <%= event.description %> \
                </p> \
              </div> \
            <%}) %>"

$.fn.tinyEventsModules.templates = templates