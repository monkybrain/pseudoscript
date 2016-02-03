# Adverb = require "./adverb"
verbs = require "./verbs/verbs"
adverbs = require "./adverbs/adverbs"
modules = require "./../modules/modules"

# Process keywords
keywords = []

# Add verbs
for verb in verbs
  for synonym in verb.lexical.synonyms
    keywords.push synonym

# Add action verb
actions = []
for m in modules
  for key, value of m.actions
    keywords.push key

# Add adverbs (FIXME: STILL A HACK, FIX IT!)
preps = ["after", "in", "wait", "in", "every", "when"]
for prep in preps
  keywords.push prep

module.exports =
  adverbs: adverbs
  verbs: verbs
  keywords: keywords