dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./set"
Add = require "./add"

module.exports =
  adverb: new Adverb dict
  verbs: [Set, Add]