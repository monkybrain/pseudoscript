dict = require "../dictionaries/base"
Adverb = require "./adverb"
Set = require "./verbs/set"
Get = require "./verbs/get"
Add = require "./verbs/add"

# List of verbs (TODO: AUTOMATIZE THIS!)
verbs = [Add, Get, Set]   # NOTE: Order important for correct parsing

# Process keywords
keywords = []

# Add verbs
for verb in verbs
  for synonym in verb.lexical.synonyms
    keywords.push synonym

# Add adverbs (TODO: STILL A HACK, FIX IT!)
adverbs = ["after", "in", "wait", "in"]
for adverb in adverbs
  keywords.push adverb

module.exports =
  adverb: new Adverb dict
  verbs: verbs
  keywords: keywords