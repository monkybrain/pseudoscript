// Generated by CoffeeScript 1.10.0

/* VERB: SET (BASED ON GET) */

(function() {
  var Find, Get, Scope, Set, Util, modules,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  modules = require("../../modules/modules");

  Find = require("./../../core/find");

  Scope = require("./../scope");

  Get = require("./get");

  Util = require("./../../core/util");

  Set = (function(superClass) {
    extend(Set, superClass);

    function Set() {
      return Set.__super__.constructor.apply(this, arguments);
    }

    Set.lexical = {
      base: 'set',
      synonyms: ['set']
    };

    Set.getValue = function(segment, object, ref, property) {
      var err, error, index, match, module, occurrence, occurrences, pattern, type, value;
      module = Find.module(object);
      try {
        type = module.properties[property].type;
      } catch (error) {
        err = error;
        console.error("Error! Invalid property in segment '" + segment + "'");
      }
      if (type === 'number') {
        match = segment.match("random");
        if (match != null) {
          value = 'random';
        } else {
          value = parseFloat(Find.number(segment));
        }
      }
      if (type === 'boolean') {
        value = Find.boolean(segment);
        console.log(value);
      }
      if (type === 'string') {
        occurrences = [
          {
            string: module.lexical.base,
            index: segment.indexOf(module.lexical.base)
          }, {
            string: ref,
            index: segment.indexOf(ref)
          }, {
            string: property,
            index: segment.indexOf(property)
          }
        ];
        occurrences.sort(function(a, b) {
          return a.index < b.index;
        });
        occurrence = occurrences[0];
        value = segment.slice(occurrence.index + occurrence.string.length + 1);
        pattern = /(\bto\b)/;
        match = value.match(pattern);
        if (match != null) {
          index = match.index + "to".length;
          value = value.slice(index).trim();
        }
      }
      return value;
    };

    Set.parse = function(segment) {
      var object, property, ref, ref1, value;
      ref1 = this.getObject(segment), object = ref1[0], ref = ref1[1];
      property = this.getProperty(segment, object);
      value = this.getValue(segment, object, ref, property);
      property = Find.module(object).properties[property].key;
      Scope.current = {
        object: object,
        ref: ref,
        property: property,
        value: value
      };
      Scope.modules[object] = {
        ref: ref,
        property: property,
        value: value
      };
      return {
        object: object,
        ref: ref,
        property: property,
        value: value
      };
    };

    Set.test = function(text) {
      var details, i, j, len, len1, match, operation, operations, pattern, properties, run, segment, split;
      pattern = /\bset .*( to)? \b(.*)\b/g;
      match = text.match(pattern);
      if (match != null) {
        split = this.split(match[0]);
        operations = [];
        for (i = 0, len = split.length; i < len; i++) {
          segment = split[i];
          details = this.parse(segment);
          run = true;
          for (j = 0, len1 = operations.length; j < len1; j++) {
            operation = operations[j];
            if (operation.ref === details.ref) {
              operation.properties[details.property] = details.value;
              run = false;
            }
          }
          if (run) {
            properties = {};
            properties[details.property] = details.value;
            operations.push({
              object: details.object,
              ref: details.ref,
              properties: properties
            });
          }
        }
        return {
          type: 'verb',
          verb: 'set',
          operations: operations,
          input: text
        };
      }
    };

    Set.random = function(object, property) {
      var k, max, min, module, ref1, v;
      module = modules.filter(function(module) {
        return module.self === object;
      })[0];
      ref1 = module.properties;
      for (k in ref1) {
        v = ref1[k];
        if (k === property) {
          max = v.max;
          min = v.min;
        }
      }
      return {
        max: max,
        min: min
      };
    };

    Set.syntax = function(phrase) {
      var i, j, key, len, len1, object, operation, option, options, properties, r, ref, ref1, syntax, value;
      syntax = [];
      ref1 = phrase.operations;
      for (i = 0, len = ref1.length; i < len; i++) {
        operation = ref1[i];
        object = operation.object, ref = operation.ref, properties = operation.properties;
        options = [];
        for (key in properties) {
          value = properties[key];
          if (value === 'random') {
            r = this.random(object, key);
            value = "Util.random min: " + r.min + ", max: " + r.max;
          }
          options.push("  " + key + ": " + value);
        }
        options[options.length - 1] = options[options.length - 1] + "\n";
        syntax.push("# Setting properties of '" + ref + "'");
        syntax.push(object + ".select '" + ref + "'");
        syntax.push(".then -> Light.set");
        for (j = 0, len1 = options.length; j < len1; j++) {
          option = options[j];
          syntax.push(option);
        }
      }
      return syntax;
    };

    return Set;

  })(Get);

  module.exports = Set;

}).call(this);
