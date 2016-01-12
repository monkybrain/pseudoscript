// Generated by CoffeeScript 1.10.0
(function() {
  var Module;

  Module = (function() {
    Module.members = [];

    function Module() {
      var key, ref1, value;
      this.properties = {};
      ref1 = this.constructor.properties;
      for (key in ref1) {
        value = ref1[key];
        this.properties[key] = value["default"];
      }
    }

    Module.add = function(ref) {
      Module.members.push({
        module: this.self,
        ref: ref
      });
      return this.members.push(ref);
    };

    Module.fetch = function(ref) {
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

  module.exports = Module;

}).call(this);
