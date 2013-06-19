# 2ch [![Build Status](https://secure.travis-ci.org/shiwano/2ch.png?branch=master)](http://travis-ci.org/shiwano/2ch)
A JavaScript library for comfortable 2ch watching.

## Getting Started
Install the module with: `npm install 2ch --save`

```javascript
var watcher = new require('2ch').ThreadWatcher('iPhone', /パズル＆ドラゴンズ/);
watcher.on('update', function(messages) {
  // do something.
});
watcher.start();
```

## Documentation
### Constructor arguments
```javascript
new ThreadWatcher(bbsName, query, interval [, bbsMenu ])
```

#### bbsName
A string which is a valid board name in 2ch.

#### query
A string or RegExp which is used to find the watched thread.

#### interval (default: 600000)
A number determining the update interval. It is at least 5000.

#### bbsMenu (default: null)
A BbsMenu instance object. In most cases, there is no need to specify.

### Methods
The ThreadWatcher class inherited from [EventEmitter2](https://github.com/hij1nx/EventEmitter2).
So you can use EventEmitter2 methods basically.

#### start
Start watching 2ch.

#### stop
Stop watching 2ch.

#### isWaching
Return `true`, when waching is started. Return `false`, otherwise.

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

#### notfound
The `notfound` event is emitted, when the watched thread is not found by specified query.

## Examples
```javascript
var ThreadWatcher = require('2ch').ThreadWatcher,
    watcher = new ThreadWatcher('番組ch(NHK)', /NHK総合を常に実況し続けるスレ/, 5000),
    loaded = false;

watcher.on('update', function(messages) {
  if (!loaded) {
    loaded = true;
    return;
  }
  messages.forEach(function(message) {
    console.log(
      message.number,
      message.name.replace(/<[^<>]+>/g, ''),
      message.postedAt.format('YYYY/MM/DD HH:mm:ss'), // moment object.
      message.tripId,
      message.body.replace(/<[^<>]+>/g, '')
    );
  });
});

watcher.on('error', function(error) {
  console.log(error);
  watcher.stop();
});

watcher.on('reload', function(title) {
  console.log(title, 'のスレッドが再読込されました');
  loaded = false;
});

watcher.on('begin', function(title) {
  console.log(title, 'のスレッドが開始しました');
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
 * 2013-06-19   v0.1.1   Modified it.
 * 2013-06-17   v0.1.0   First release.

## License
Copyright (c) 2013 Shogo Iwano
Licensed under the MIT license.
