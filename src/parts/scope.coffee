modules = require "../modules/modules"

class Scope

  @modules: []
  @current: {}
  @type: null
  @subtype: null

  @getByRef: (ref) =>
    for k, v of @modules
      if ref is v.ref
        return k

module.exports = Scope