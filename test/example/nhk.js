var _2ch = require('../../lib/2ch'),
    ThreadWatcher = _2ch.ThreadWatcher,
    BbsMenu = _2ch.BbsMenu;

var bbsMenu = new BbsMenu(); // common object

var watcher = new ThreadWatcher({
  bbsName: '番組ch(NHK)',
  query: /NHK総合を常に実況し続けるスレ/,
  interval: 5000, // at least 5000
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
