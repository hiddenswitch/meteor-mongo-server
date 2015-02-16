meteor-mongodb-mapreduce-aggregation
====================================

An authoritative MongoDB `aggregate`, `mapReduce` and `distinct` package for Meteor. This differs from other packages
by including tests and letting you pass options to calls to aggregate.

##### Documentation

`Mongo.Collection` on the server is extended with with 3 methods: `mapReduce`, `distinct` and `aggregate`. You can
specify `options` for `aggregate` when using MongoDB 2.6 or later in hosted environments.

When specifying options, make sure to include a `readPreference` field, e.g., `{readPreference: 'primary'}`. Read more
about [read preferences](http://docs.mongodb.org/manual/core/read-preference/).

```coffeescript
    col = new Meteor.Collection "name"

    if Meteor.isServer
        # mapReduce
        map = function() {emit(this.Region, this.Amount);}
        reduce = function(reg, am) { return Array.sum(am);};

        col.mapReduce map, reduce, {out: "out_collection_name", verbose: true}, (err,res)->
            console.dir res.stats # statistics object for running mapReduce

        # distinct
        result = col.distinct "Field Name"
        console.dir result

        #aggregate
        result = col.aggregate pipeline
        console.dir result
```

Another [mapReduce](http://docs.mongodb.org/manual/core/map-reduce/) example in javascript:
```javascript

    // on the server side
    /////////////////////

    Posts = new Mongo.Collection("Posts");
    Tags = new Mongo.Collection("Tags");

    Meteor.methods({

        mostUsedTags: function() {
            var map = function() {
                if (!this.tags) {
                    return;
                }

                for (index in this.tags) {
                    emit(this.tags[index], 1);
                }
            }

            var reduce = function(previous, current) {
                var count = 0;

                for (index in current) {
                    count += current[index];
                }

                return count;
            }

            // keep in mind that executing the mapReduce function will override every time the collection Tags
            var result = Posts.mapReduce(map, reduce, {query: {}, out: "Tags", verbose: true});

            // now return all the tags, ordered by usage
            // as an alternative solution you can also publish the collection Tags and use this one at the client side
            return Tags.find({},{ sort: {'value': -1}, limit:10}).fetch();
        }

    });

    // on the client side you could do
    //////////////////////////////////

    Meteor.call("mostUsedTags", function(err, data) {
        console.log(data);
    });

```

To install it, run:
```bash
$ meteor add doctorpangloss:mongodb-mapreduce-aggregation
```

This package is MIT Licensed.
