// From https://github.com/meteorhacks/meteor-aggregate/blob/master/test.js
// Thanks to Arunoda
Tinytest.add('aggregation function', function (test) {
    var coll = new Mongo.Collection(Random.id());
    test.equal(typeof coll.aggregate, 'function');
});

Tinytest.add('aggregation', function (test) {
    var coll = new Mongo.Collection(Random.id());
    coll.insert({resTime: 20});
    coll.insert({resTime: 40});

    var result = coll.aggregate([
        {$group: {_id: null, resTime: {$sum: "$resTime"}}}
    ]);

    test.equal(result, [{_id: null, resTime: 60}]);
});

Tinytest.add('aggregate on Meteor.users', function (test) {
    var coll = Meteor.users;
    coll.remove({});
    coll.insert({resTime: 20});
    coll.insert({resTime: 40});

    var result = coll.aggregate([
        {$group: {_id: null, resTime: {$sum: "$resTime"}}}
    ]);

    test.equal(result, [{_id: null, resTime: 60}]);
});