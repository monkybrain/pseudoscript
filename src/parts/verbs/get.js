// Generated by CoffeeScript 1.10.0

/* VERB: GET */

(function() {
  var Find, Get, Module, Scope, Util, Verb, modules,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  modules = require("../../modules/modules");

  Module = require("../../modules/module");

  Scope = require("./../scope");

  Find = require("./../../core/find");

  Verb = require("./verb");

  Util = require("./../../core/util");

  Get = (function(superClass) {
    extend(Get, superClass);

    function Get() {
      return Get.__super__.constructor.apply(this, arguments);
    }

    Get.lexical = {
      base: 'get',
      synonyms: ['get']
    };

    Get.getObject = function(segment) {

      /* FIND OBJECT AND REFERENCE */
      var err, error, i, len, match, module, object, pattern, ref, refs, words;
      for (i = 0, len = modules.length; i < len; i++) {
        module = modules[i];
        words = [module.lexical.base, module.lexical.plural];
        pattern = Util.regex.groupAndBound(words);
        match = segment.match(pattern);
        if (match != null) {
          object = module.self;
          break;
        }
      }
      refs = Find.references(segment);
      console.log(refs);
      if (refs != null) {
        ref = refs[0];
      }
      if (object == null) {
        if (ref != null) {
          try {
            object = Module.fetch(ref).module;
          } catch (error) {
            err = error;
            console.error("Error! '" + ref + "' not found.");
          }
        } else {
          object = Scope.current.object;
          ref = Scope.current.ref;
        }
      } else {

        /*if ref?
          try
            object = Module.fetch(ref).module
          catch err
            console.error "Error! '#{ref}' not found."
         */
        ref = Scope.modules[object].ref;
      }
      return [object, ref];
    };

    Get.getProperty = function(segment, object) {

      /* FIND PROPERTY */
      var key, match, module, property, ref1, value;
      module = Find.module(object);
      ref1 = module.properties;
      for (key in ref1) {
        value = ref1[key];
        match = segment.match(key);
        if (match != null) {
          property = key;
        }
      }
      if (property == null) {
        property = Scope.modules[object].property;
      }
      return property;
    };

    Get.parse = function(segment) {
      var object, property, ref, ref1;
      ref1 = this.getObject(segment), object = ref1[0], ref = ref1[1];
      property = this.getProperty(segment, object);
      property = Find.module(object).properties[property].key;
      Scope.current = {
        object: object,
        ref: ref,
        property: property
      };
      Scope.modules[object] = {
        ref: ref,
        property: property
      };
      return {
        object: object,
        ref: ref,
        property: property
      };
    };

    Get.test = function(text) {
      var details, i, j, len, len1, match, operation, operations, pattern, properties, run, segment, split;
      pattern = /\bget .*( to)? \b(.*)\b/g;
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
              operation.properties.push(details.property);
              run = false;
            }
          }
          if (run) {
            properties = [];
            properties.push(details.property);
            operations.push({
              object: details.object,
              ref: details.ref,
              properties: properties
            });
          }
        }
        return {
          type: 'verb',
          verb: 'get',
          operations: operations
        };
      }
    };

    Get.syntax = function(phrase, level) {
      var i, j, len, len1, object, operation, prefix, properties, property, props, ref, ref1, syntax;
      syntax = [];
      ref1 = phrase.operations;
      for (i = 0, len = ref1.length; i < len; i++) {
        operation = ref1[i];
        object = operation.object, ref = operation.ref, properties = operation.properties;
        props = [];
        for (j = 0, len1 = properties.length; j < len1; j++) {
          property = properties[j];
          props.push("'" + property + "'");
        }
        syntax.push("# Get properties of '" + ref + "'");
        prefix = level !== 0 ? ".then -> " : "";
        syntax.push(prefix + (object + ".get '" + ref + "', ") + props.join(", "));
        syntax.push(".then (result) -> Globals.set result\n");
      }
      return syntax;
    };

    return Get;

  })(Verb);

  module.exports = Get;

}).call(this);
