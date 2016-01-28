// Generated by CoffeeScript 1.10.0
var Add, Find, Scope, Util, Verb,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Find = require("./../../core/find");

Scope = require("./../scope");

Verb = require("./verb");

Util = require("./../../core/util");

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
    var direct, group, indirect, match, objects, refs;
    direct = {};
    indirect = {};
    refs = Find.references(text);
    objects = Find.objects(text);
    match = text.match(/\bto\b/g);
    if (match != null) {
      group = objects.map(function(object) {
        return Find.word(object);
      });
      group = "(" + Util.regex.group(group) + ")";
      match = text.match(new RegExp("(to\\s+?(\\w+?\\s+?)*)" + group));
      if (match != null) {
        indirect.type = Find.object(match[3]);
      }
      if (refs != null) {
        group = "(" + Util.regex.group(refs) + ")";
        match = text.match(new RegExp("(to\\s+?(\\w+?\\s+?)*)'" + group + "'"));
        if (match != null) {
          indirect.ref = match[3];
        }
      }
    }
    if (objects != null) {
      direct.type = objects[0];
    }
    if (refs != null) {
      refs = refs.filter(function(ref) {
        return ref !== indirect.ref;
      });
      direct.ref = refs[0];
    }
    return [direct, indirect];
  };

  Add.test = function(text) {
    var direct, indirect, match, module, pattern, ref1, scope;
    pattern = this.lexical.regex();
    match = text.match(pattern);
    if (match != null) {
      ref1 = Add.parse(text), direct = ref1[0], indirect = ref1[1];
      module = Find.module(direct.type);
      if (direct.ref == null) {
        direct.ref = module.lexical.base + "_" + module.index;
      }
      if (indirect.ref == null) {
        scope = Scope.modules[indirect.type];
        if (scope != null) {
          indirect.ref = scope.ref;
        }
      }
      if (indirect.type == null) {
        indirect.type = Find.getModuleByRef(indirect.ref);
      }
      module.add(direct.ref);
      Scope.modules[direct.type] = {
        ref: direct.ref
      };
      Scope.current = {
        object: direct.type,
        ref: direct.ref
      };
      return {
        type: 'verb',
        verb: 'add',
        object: {
          type: direct.type,
          ref: direct.ref
        },
        parent: {
          type: indirect.type,
          ref: indirect.ref
        }
      };
    }
  };

  Add.syntax = function(phrase) {
    var object, parent;
    object = phrase.object, parent = phrase.parent;
    if (parent.ref != null) {
      return ["# Adding new " + object.type + " '" + object.ref + "' to " + parent.type + " '" + parent.ref + "'", "new " + object.type + " '" + object.ref + "', '" + parent.ref + "'\n"];
    } else {
      return ["# Adding new " + object.type + " '" + object.ref + "'", "new " + object.type + " '" + object.ref + "'\n"];
    }
  };

  return Add;

})(Verb);

module.exports = Add;
