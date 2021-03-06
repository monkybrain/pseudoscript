### DICTIONARY: SWEDISH ###

### NOT TESTED, JUST PROOF OF CONCEPT ###

dictionary =

  adverbs:
    time:
      units:
        milliseconds: ["millisekund(er)?", "ms"]
        seconds: ["sekund(er)?", "sek", "s"]
        minutes: ["minut(er)?", "min", "m"]
        hours: ["timm((e)|(ar))?", "h"]
        days: ["dag(ar)?", "d"]
      types:
        delay:
          prepositions: ["om", "efter", "vänta"]
        interval:
          prepositions: ["varje"]

  preprocessor:
    numbers:
      '0': ["noll"]
      '1': ["en", "ett"]
      '2': ["två"]
      '3': ["tre"]
      '4': ["fyra"]
      '5': ["fem"]
      '6': ["sex"]
      '7': ["sju"]
      '8': ["åtta"]
      '9': ["nio"]
      '10': ["tio"]
      '11': ["elva"]
      '12': ["tolv"]

module.exports = dictionary

