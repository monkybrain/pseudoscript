// Generated by CoffeeScript 1.10.0
(function() {
  var Util;

  Util = (function() {
    function Util() {}

    Util.find = {
      string: function(text) {
        var end, indices, match, pattern, reference, start;
        pattern = /"|'/g;
        indices = [];
        while (true) {
          match = pattern.exec(text);
          if (match != null) {
            indices.push(match.index);
          } else {
            break;
          }
        }
        if (indices.length > 0) {
          start = indices[0] + 1;
          end = indices[1];
          reference = text.slice(start, end);
        }
        return reference;
      }
    };

    return Util;

  })();

  module.exports = Util;

}).call(this);
