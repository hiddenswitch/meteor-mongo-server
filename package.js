Package.describe({
    summary: "Meteor 0.9+ supported mongodb aggregation framework",
    version: "1.0.5",
    name: "doctorpangloss:mongodb-server-aggregation",
    git: "https://github.com/hiddenswitch/meteor-mongo-server.git"
});

Npm.depends({
    mongodb: "https://github.com/meteor/node-mongodb-native/tarball/cbd6220ee17c3178d20672b4a1df80f82f97d4c1"
});

Package.onUse(function (api) {
    api.versionsFrom('METEOR@0.9.0');

    api.use('coffeescript', 'server');
    api.use('underscore', 'server');

    api.addFiles('server.coffee', 'server');

});
