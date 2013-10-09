TinyEvents
==========

Calendar jQuery plugin with events support


![alt tag](http://i41.tinypic.com/k4utj7.png)


Installation
------------
Plugin uses  jQuery 1.10.2 and also depends on Underscore.js (there is a good chance that you've already using it in your project)

```html
<!DOCTYPE html>
<html>
  <head>
    <title>jQuery Boilerplate</title>
    <script type="text/javascript" src="scripts/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/underscore-min.js"></script>
    <script src="scripts/tinyEvents.js"></script> <!-- or min version -->

    <link rel="stylesheet" type="text/css" href="css/index.css">
  </head>
  <body>
    <div id="element"></div>

    <script>
      $(function() {
        var events = [
          {
            title: 'Watch Adventure Time with friends'
            , description: "Also, watch last episode of Breaking Bad one more time"
            , time: new Date(2013, 9, 4, 16, 00)
          }
        , {
            title: 'Let the dog out'
            , description: 'Buy him some toy. He ate last one (visit the doctor!)'
            , time: new Date(2013, 9, 4, 17, 30)
          },
          {
            title: 'Buy flowers for my wife'
            , description: "Roses probably"
            , time: new Date(2013, 9, 4, 19, 30)
          }
        ];

        $("#element").tinyEvents({
          events: events,
          handlers: {
            onDateChange: function (e) { console.log('date change: ', e) },
            onYearChange: function (e) { console.log('year change: ', e) },
            onMonthChange: function (e) { console.log('month change: ', e) },
            onDayChange: function (e) { console.log('day change: ', e) },
            onInit: function () { console.log('on init') },
            onInitComplete: function () { console.log('on init complete') },
          }
        });
      });
    </script>
  </body>
</html>
```

API
---
You can subscribe to the events during plugin initialization, like this:
```javascript
$('oh-yeah-super-selector').tinyEvents({
  handlers: {
    onDateChange: yourHandler,
    //...other events
  }
});
```

To use methods you need to get tinyEvents object first, like this:
```javascript
var tinyEvents = $('oh-yeah-futurama-time-selector').data('tinyEvents');
var selectedDate = tinyEvents.getSelectedDate();
```

####Events:
- onDateChange - happens when user changes day, month or year
- onDayChange - user changes month's date
- onMonthChange - user changes month
- onYearChange - user changes year
- onInit - happens in the beginning of the plugin initialization
- onInitComplete - happens in the end of the plugin initialization

####Methods:
- getSelectedDate() - returns selected date
- getDateEvents(date) - returns an array of events for a specific date
- getAllEvents() - returns all events grouped by date
- addEvents([event1, event2, ..eventN]) - adds events to the calendar
- removeEvents([event1, event2, ..eventN]) - removes events from the calendar
- resetEvents([event1, event2, ..eventN]) - replaces already existing events with the passed ones
- subscribe('eventName', callback) - subscribes to the event (like onDateChange, onDayChange, etc.)
- unsubscribe('eventName', callback) - unsubscribes from the event

####Calendar events
Calendar event is an object with next properties:
- title
- description
- time

Example:
```javascript
var testEvent = {
    title: "hello, I'm an event",
    description: "hello, I'm event's description",
    time: new Date(Date.now())
}

//the event can be added to the calendar
var tinyEvents = $('selector').data('tinyEvents');
tinyEvents.addEvent(testEvent);
```

Development
-----------
For those who wants to add/change code:
I've used bower and grunt for development of the plugin, so you need to install
underscore and jquery with bower by typing next lines in the terminal:

```sh
bower install jquery
bower install underscore
```

and also use npm to install dependencies:

```sh
npm install
```

after everything is installed you can use grunt watch to recompile solution while
you changing/updating the code, to do this, type next lines in the terminal:

```sh
grunt watch
```

Compiled and minified version would be in the 'dist' folder

####Technologies
- jQuery
- Underscore.js
- SASS
- Grunt
- Bower

License
-------
The MIT License (MIT)

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
