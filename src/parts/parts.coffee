dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./verbs/set"
Get = require "./verbs/get"
Add = require "./verbs/add"

module.exports =
  adverb: new Adverb dict
  verbs: [Add, Get, Set]   # NOTE: Order important for correct parsing