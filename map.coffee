class Universe

  @self = 'universe'
  @Self = 'Universe'

  constructor: () ->
    @members = []
    @scope = null

  add: (object) ->
    @members.push(object)
    @scope = @members[@members.length - 1]


### ABSTACTS: NOUN ###
class Noun extends Universe

  @count: 0
  @scope: null

  ref: null

  constructor: (property) ->
    @members = []
    @index++
    @property = property

  set: (property, value) ->

  get: (property, value) ->

  state: {}

  property: {}

### CONCRETES: ROOM, LIGHT ###
class Light extends Noun

  @self = 'light'
  @Self = 'Light'

  @lexical =
    word: 'light'
    article:
      def: 'the'
      indef: 'a'

  constructor: (ref) ->
    @ref = ref
    @index = Light.count++
    Noun.count++

    property =
      'on': false
      'brightness': 45
      'color': 'blue'

    super(property)

class Room extends Noun

  @self = 'room'
  @Self = 'Room'

  @lexical =
    word: 'room'
    article:
      def: 'the'
      indef: 'a'

  constructor: (ref) ->
    @ref = ref
    Noun.scope = this
    @index = Room.count++
    Noun.count++


    property =
      'size': 20
      'windows': 2

    super(property)

module.exports = {
  abstracts:
    Universe: Universe
    Noun: Noun
  concretes: [Room, Light]
}


