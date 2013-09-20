templates = 
  tinyEvents: "<div class='tiny-events'></div>"

  calendar: "<div class='calendar'> \
                <div class='current'> \
                  <div class='year'> \
                    <img class='prev' src='images/blue_left.png'> \
                    <span> <%= year %> </span> \
                    <img class='next' src='images/blue_right.png'> \
                  </div> \

                  <span class='date'><%= day %></span> \
                  <br>
                  <span class='weekday'>Wednesday</span> \
                </div> \

                <div class='all'> \
                  <div class='month'> \
                    <img class='prev' src='images/white_left.png'> \
                    <span><%= month %></span> \
                    <img class='next' src='images/white_right.png'> \
                  </div> \

                  <table> \
                    <% for (var i = 1; i <= days; i++) { %> \
                      <% if ((i - 1) % 7 === 0) { %> \
                        <tr> \
                      <% } %> \

                      <td> <%= i %> </td> \

                      <% if (i % 7 === 0) { %> \
                        </tr> \
                      <% } %> \
                    <% } %> \
                  </table> \
                </div> \
              </div>"

  events: "<div class='events'> \
            <div> \
              <span class='time'>18:23</span> \
              <p class='title'> Here is a good description of the fucked up shit. Here is a good description of the fucked up shit. Here is a good description of the fucked up shit. </p> \
            </div> \

            <div class='has-description'> \
              <span class='time'>12:00</span> \
              <p class='title'> Karl stole corales from Karla </p> \
              <p class='description'> \
                Ahis is a total disaster when you understand that \
                you are very different from your friends, event \C8EAF5 81B4D3
                the closest ones. Sudden feel of loneliness is \
                inevitable. \
              </p> \
            </div> \

            <div class='last'> \
              <span class='time'>08:42</span> \
              <p class='title'> Strange formation in your eye </p> \
            </div> \
          </div>"

$.fn.tinyEventsModules.templates = templates