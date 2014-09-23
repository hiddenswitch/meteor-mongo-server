Package.describe({
    summary: "Meteor 0.9+ supported mongodb aggregation framework",
    version: "1.0.4",
    name: "hiddenswitch:mongodb-server-aggregation",
    git: "https://github.com/hiddenswitch/meteor-mongo-server.git"
});

Npm.depends({mongodb: "1.3.17"});

Package.onUse(function (api) {
    api.versionsFrom('METEOR@0.9.0');

    api.use('coffeescript', 'server');
    api.use('underscore', 'server');

    api.addFiles('server.coffee', 'server');

});
