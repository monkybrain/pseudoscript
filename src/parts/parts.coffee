# Adverb = require "./adverb"
verbs = require "./verbs/verbs"
adverbs = require "./adverbs/adverbs"

# Process keywords
keywords = []

# Add verbs
for verb in verbs
  for synonym in verb.lexical.synonyms
    keywords.push synonym

# Add adverbs (FIXME: STILL A HACK, FIX IT!)
preps = ["after", "in", "wait", "in", "every"]
for prep in preps
  keywords.push prep

module.exports =
  adverbs: adverbs
  verbs: verbs
  keywords: keywords