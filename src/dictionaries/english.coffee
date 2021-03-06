### DICTIONARY: ENGLISH ###

dictionary =

  adverbs:
    time:
      units:
        milliseconds: ["millisecond(s)?", "ms"]
        seconds: ["second(s)?", "sec(s)?", "s"]
        minutes: ["minute(s)?", "min(s)?", "m"]
        hours: ["hour(s)?", "h"]
        days: ["day(s)?", "d"]
      types:
        delay:
          prepositions: ["in", "after", "wait"]
        interval:
          prepositions: ["every"]
    'when':
      types:
        when:
          prepositions: ['when', 'on']

  preprocessor:
    numbers:
      '0': ["zero", "nil"]
      '1': ["one"]
      '2': ["two"]
      '3': ["three"]
      '4': ["four"]
      '5': ["five"]
      '6': ["six"]
      '7': ["seven"]
      '8': ["eight"]
      '9': ["nine"]
      '10': ["ten"]
      '11': ["eleven"]
      '12': ["twelve"]

module.exports = dictionary

