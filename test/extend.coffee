moduleKeywords = ['extended', 'included']

class Module

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value
    obj.extended?.apply(@)
    @

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @::[key] = value

class Parent

  @test: () ->
    console.log "parent"


class Child extends Parent

  @one: 1

  @test: () ->
    super()
    console.log @::one

  @test2: () ->
    @test()


Child.test2()