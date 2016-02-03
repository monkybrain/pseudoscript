// Generated by CoffeeScript 1.10.0
(function() {
  var Adverb, Time, Util, dict,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Adverb = require("./adverb");

  Util = require("./../../core/util");

  dict = require("../../dictionaries/dictionary").adverbs;

  Time = (function(superClass) {
    extend(Time, superClass);

    function Time() {
      return Time.__super__.constructor.apply(this, arguments);
    }

    Time.types = dict.time.types;

    Time.units = dict.time.units;

    Time.getPrepositions = function() {
      var i, k, len, preposition, prepositions, ref, ref1, v;
      prepositions = [];
      ref = this.types;
      for (k in ref) {
        v = ref[k];
        ref1 = v.prepositions;
        for (i = 0, len = ref1.length; i < len; i++) {
          preposition = ref1[i];
          prepositions.push(preposition);
        }
      }
      return prepositions;
    };

    Time.getType = function(preposition) {
      var i, k, len, p, ref, ref1, v;
      ref = this.types;
      for (k in ref) {
        v = ref[k];
        ref1 = v.prepositions;
        for (i = 0, len = ref1.length; i < len; i++) {
          p = ref1[i];
          if (preposition === p) {
            return k;
          }
        }
      }
    };

    Time.getUnits = function() {
      var i, k, len, ref, unit, units, v;
      units = [];
      ref = this.units;
      for (k in ref) {
        v = ref[k];
        for (i = 0, len = v.length; i < len; i++) {
          unit = v[i];
          units.push(unit);
        }
      }
      return units;
    };

    Time.getUnit = function(expression) {
      var i, k, len, pattern, ref, unit, v;
      ref = this.units;
      for (k in ref) {
        v = ref[k];
        for (i = 0, len = v.length; i < len; i++) {
          unit = v[i];
          pattern = new RegExp("\\b" + unit + "\\b");
          if (expression.match(pattern) != null) {
            return k;
          }
        }
      }
    };

    Time.getTime = function(text) {
      var i, j, len, len1, match, pattern, result, results, time, unit, units, value, whitespace, whole;
      units = this.getUnits();
      results = [];
      for (i = 0, len = units.length; i < len; i++) {
        unit = units[i];
        pattern = "(\\d+)(\\s+)?(" + unit + ")((\\d+)|(\\b)|(\\s+))";
        match = text.match(pattern);
        if (match != null) {
          whole = match[0], value = match[1], whitespace = match[2], unit = match[3];
          results.push([value, unit]);
        }
      }
      time = {};
      for (j = 0, len1 = results.length; j < len1; j++) {
        result = results[j];
        value = result[0], unit = result[1];
        value = parseFloat(value);
        unit = this.getUnit(unit);
        time[unit] = time[unit] != null ? time[unit] += value : value;
      }
      return this.time2sec(time);
    };

    Time.test = function(text) {
      var match, pattern, preposition, time, type;
      pattern = Util.regex.bound(Util.regex.group(this.getPrepositions()));
      match = text.match(pattern);
      if (match != null) {
        preposition = match[0];
        type = this.getType(preposition);
        time = this.getTime(text);
        return {
          type: 'adverb',
          adverb: type,
          time: time
        };
      }
    };

    Time.time2sec = function(time) {
      var seconds;
      seconds = 0;
      if (time.days != null) {
        seconds += time.days * 60 * 60 * 24;
      }
      if (time.hours != null) {
        seconds += time.hours * 60 * 60;
      }
      if (time.minutes != null) {
        seconds += time.minutes * 60;
      }
      if (time.seconds != null) {
        seconds += time.seconds;
      }
      if (time.milliseconds != null) {
        seconds += time.milliseconds / 1000;
      }
      return seconds;
    };

    Time.syntax = function(phrase) {
      var adverb, close, open, time;
      adverb = phrase.adverb, time = phrase.time;
      if (adverb === 'delay') {
        open = ["# Set timeout to " + time + " seconds", "setTimeout ->\n"];
        close = [", " + time + " * 1000\n"];
      }
      if (adverb === 'interval') {
        open = ["# Set interval to " + time + " seconds", "setInterval ->\n"];
        close = [", " + time + " * 1000\n"];
      }
      return [open, close];
    };

    return Time;

  })(Adverb);

  module.exports = Time;

}).call(this);
