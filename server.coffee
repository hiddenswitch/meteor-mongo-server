#hacky advanced mongo definitions based on https://github.com/meteor/meteor/pull/644

path = Npm.require("path")
Future = Npm.require(path.join("fibers", "future"))
Collection = if Mongo?.Collection then Mongo.Collection else Meteor.Collection

_dummyCollection_ = new Collection '__dummy__'

_mongoCollection = ( collection )->
  col = if (typeof collection) == "string" then  _dummyCollection_ else collection
  collectionName = if (typeof collection) == "string" then  collection else collection._name
  coll1 = null
  col.find()._mongo._withDb ( db )-> coll1 = MongoInternals.NpmModule.Collection db, collectionName
  coll1

# Wrapper of the call to the db into a Future
_futureWrapper = (collection, commandName, args)->
  coll1 = _mongoCollection collection
  future = new Future
  cb = future.resolver()
  args = args.slice()
  args.push(cb)
  coll1[commandName]?.apply(coll1, args)
  result = future.wait()



# Not really DRY, but have to return slightly different results from mapReduce as mongo method returns
# a mongo collection, which we don't need here at all
_callMapReduce = (collection, map, reduce, options)->
  coll1 = _mongoCollection collection

  future = new Future
  coll1.mapReduce map, reduce, options, (err,result,stats)->
      future.throw(err) if err
      res = {collectionName: result.collectionName, stats: stats}
      future.return [true,res]

  result = future.wait() #
  throw result[1] if !result[0]
  result[1]



# Extending Collection on the server

_.extend Collection::,

  distinct: (key, query, options) ->
    #_collectionDistinct @_name, key, query, options
    _futureWrapper @_name, "distinct", [key, query, options]

  aggregate: (pipeline, options) ->
    args = [pipeline]
    # Passing undefined options to aggregate is meaningful
    if options
      args = [pipeline, options]
    _futureWrapper @_name, "aggregate", args

  mapReduce: (map, reduce, options)->
    options = options || {};
    options.readPreference = "primary";
    _callMapReduce @_name, map, reduce, options