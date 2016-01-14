// Generated by CoffeeScript 1.10.0
(function() {
  var Add, Find, Scope, Verb,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Find = require("./../find");

  Scope = require("./../scope");

  Verb = require("./verb");

  Add = (function(superClass) {
    extend(Add, superClass);

    function Add() {
      return Add.__super__.constructor.apply(this, arguments);
    }

    Add.lexical = {
      base: 'add',
      synonyms: ['add', 'create'],
      regex: function() {
        var synonyms;
        synonyms = this.synonyms.map(function(synonym) {
          return synonym = "(" + synonym + ")";
        });
        return new RegExp("\\b(" + (synonyms.join("|")) + ")\\b", "g");
      }
    };

    Add.parse = function(text) {
      var object, ref;
      object = Find.object(text);
      ref = Find.reference(text);
      return [object, ref];
    };

    Add.test = function(text) {
      var match, module, object, pattern, ref, ref1;
      pattern = this.lexical.regex();
      match = text.match(pattern);
      if (match != null) {
        ref1 = Add.parse(text), object = ref1[0], ref = ref1[1];
        module = Find.module(object);
        if (ref == null) {
          ref = module.lexical.base + module.index;
        }
        module.add(ref);
        Scope.modules[object] = {
          ref: ref
        };
        Scope.current = {
          object: object,
          ref: ref
        };
        return {
          type: 'verb',
          verb: 'add',
          object: object,
          ref: ref
        };
      }
    };

    Add.syntax = function(phrase) {
      var object, ref, syntax;
      object = phrase.object, ref = phrase.ref;
      return syntax = ["# Adding new " + object + " called '" + ref + "'", "new " + object + "('" + ref + "')\n"];
    };

    return Add;

  })(Verb);

  module.exports = Add;

}).call(this);
