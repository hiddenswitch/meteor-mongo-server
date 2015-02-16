Package.describe({
    summary: "Expose the Mongo aggregation methods mapReduce, aggregate and distinct with options",
    version: "1.1.0",
    name: "doctorpangloss:mongodb-server-aggregation",
    git: "https://github.com/hiddenswitch/meteor-mongo-server.git"
});

function configurePackage(api) {

  if(api.versionsFrom) {
    api.versionsFrom('METEOR@1.0.1');
  }

  // Core Dependencies
  api.use(
    [
      'meteor'
    ]
  );

  api.use('coffeescript', 'server');
  api.use('underscore', 'server');

  api.addFiles('server.coffee', 'server');
}

Package.onUse(function(api) {
  configurePackage(api);
});

Package.onTest(function(api) {
  configurePackage(api);

  api.use('tinytest');
  api.use('accounts-base');
  api.addFiles('server-tests.js', 'server'); // no tests yet
});
