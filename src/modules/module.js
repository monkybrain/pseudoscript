// Generated by CoffeeScript 1.10.0
(function() {
  var Find, Module, fisk;

  Find = require("./../core/find");

  Module = (function() {
    Module.index = 0;

    Module.members = [];

    Module.children = [];

    Module.parent = null;


    /*
    constructor: (ref) ->
      console.log "Module: " + ref
      return
       * Set default values
      @properties = {}
      for key, value of @constructor.properties
        @properties[key] = value.default
     */

    function Module(ref1) {
      this.ref = ref1;
    }

    Module.add = function(ref, parent) {
      Module.members.push({
        module: this.self,
        ref: ref
      });
      this.members.push(ref);
      return this.index++;
    };

    Module.select = function(ref) {
      var i, len, member, ref1;
      ref1 = this.members;
      for (i = 0, len = ref1.length; i < len; i++) {
        member = ref1[i];
        if (ref === member.ref) {
          return member;
        }
      }
    };

    return Module;

  })();

  fisk = new Module('test');

  console.log(fisk);

  module.exports = Module;

}).call(this);
