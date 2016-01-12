dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./verbs/set"
Get = require "./verbs/get"
Add = require "./verbs/add"

# List of verbs (TODO: AUTOMATIZE THIS!)
verbs = [Add, Get, Set]

# Process keywords
keywords = []
for verb in verbs
  for synonym in verb.lexical.synonyms
    keywords.push synonym

console.log keywords

module.exports =
  adverb: new Adverb dict
  verbs: verbs   # NOTE: Order important for correct parsing
  keywords: keywords