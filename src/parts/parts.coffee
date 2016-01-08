dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./set"

module.exports =
  adverb: new Adverb dict
  set: new Set dict