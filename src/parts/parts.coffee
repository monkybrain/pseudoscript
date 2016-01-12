dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./verbs/set"
Add = require "./verbs/add"

module.exports =
  adverb: new Adverb dict
  verbs: [Add, Set]   # NOTE: Order important for correct parsing