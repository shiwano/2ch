# 2ch
A JavaScript library for comfortable 2ch watching.

## Getting Started
Install the module with: `npm install 2ch --save`

```javascript
var watcher = new require('2ch').ThreadWatcher({
  bbsName: 'iPhone',
  query: /パズル＆ドラゴンズ/,
});
watcher.on('update', function(messages) {
  // do something.
});
watcher.start();
```

## Documentation
### Events
#### update
The `update` event is emitted, when the watched thread has new messages.
The callback take the `messages` argument.

```javascript
watcher.on('update', function(messages) {
  messages.forEach(function(message) {
    console.log(
      message.number,
      message.postedAt.format('YYYY/MM/DD HH:mm:ss'), // moment object.
      message.name,
      message.mail,
      message.tripId,
      message.body
    );
  });
});
```

#### error
The `error` event is emitted, when a error occured in the library.
The callback take the `error` argument.

If there is no listener for it, then the default action is to print a stack trace and exit the program.

#### reload
The `reload` event is emitted, when the watched thread is reloaded for deleting a message.
The callback take the `title` argument.

#### begin
The `begin` event is emitted, when the watched thread is found.
The callback take the `title` argument.

#### end
The `end` event is emitted, when the watched thread is ended.
The callback take the `title` argument.

## Examples
```javascript
var _2ch = require('2ch'),
    ThreadWatcher = _2ch.ThreadWatcher,
    BbsMenu = _2ch.BbsMenu;

var bbsMenu = new BbsMenu(); // common object

var watcher = new ThreadWatcher({
  bbsName: '番組ch(NHK)',
  query: /NHK総合を常に実況し続けるスレ/,
  interval: 60000, // at least 5000
  bbsMenu: bbsMenu
});

watcher.on('update', function(messages) {
  messages.forEach(function(message) {
    console.log(message.number, message.rawString);
  });
});

watcher.on('error', function(error) {
  console.log(error);
});

watcher.on('begin', function(title) {
  console.log(title, 'のスレッドが立てられました');
});

watcher.on('end', function(title) {
  console.log(title, 'のスレッドが終了しました');
});

watcher.start();
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## TODO
 * Browserify

## Release History
 * 2013-06-17   v0.1.0   First release.

## License
Copyright (c) 2013 Shogo Iwano
Licensed under the MIT license.
