#hacky advanced mongo definitions based on https://github.com/meteor/meteor/pull/644

path = Npm.require("path")
MongoDB = Npm.require("mongodb")
Future = Npm.require(path.join("fibers", "future"))

_dummyCollection_ = new Meteor.Collection '__dummy__'

# Wrapper of the call to the db into a Future
_futureWrapper = (collection, commandName, args)->
  col = if (typeof collection) == "string" then  _dummyCollection_ else collection
  collectionName = if (typeof collection) == "string" then  collection else collection._name

  coll1 = col.find()._mongo.db.collection(collectionName)

  future = new Future
  cb = future.resolver()
  args = args.slice()
  args.push(cb)
  coll1[commandName].apply(coll1, args)
  result = future.wait()



# Not really DRY, but have to return slightly different results from mapReduce as mongo method returns
# a mongo collection, which we don't need here at all
_callMapReduce = (collection, map, reduce, options)->
  col = if (typeof collection) == "string" then  _dummyCollection_ else collection
  collectionName = if (typeof collection) == "string" then  collection else collection._name

  coll1 = col.find()._mongo.db.collection(collectionName)

  future = new Future
  #cb = future.resolver()
  coll1.mapReduce map, reduce, options, (err,result,stats)->
      future.throw(err) if err
      res = {collectionName: result.collectionName, stats: stats}
      future.return [true,res]

  result = future.wait() #
  #console.log "Result from the callMapReduce is: "
  #console.dir result[1]
  throw result[1] if !result[0]
  result[1]



# Extending Collection on the server
_.extend Meteor.Collection::,

  distinct: (key, query, options) ->
    #_collectionDistinct @_name, key, query, options
    _futureWrapper @_name, "distinct", [key, query, options]

  aggregate: (pipeline) ->
    _futureWrapper @_name, "aggregate", [pipeline]

  mapReduce: (map, reduce, options)->
    options = options || {};
    options.readPreference = "primary";
    _callMapReduce @_name, map, reduce, options
