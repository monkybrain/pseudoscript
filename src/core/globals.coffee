class Globals

  @variables = {}

  @set: (object) ->
    new Promise (resolve, reject) =>
      for key, value of object
        if key is 'set'
          reject "Cannot name global variable 'set'"
        else
          this[key] = value
      resolve object

module.exports = Globals