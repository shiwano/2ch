var ThreadWatcher = require('../../lib/2ch').ThreadWatcher,
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
