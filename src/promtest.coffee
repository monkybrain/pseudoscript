Promise = require "promise"
Photon = require "./js/photon"

photon = new Photon()
photon.connect().then(
  () ->
    setTimeout () ->
      photon.set('color', 'red')
    , 1000
    setTimeout () ->
      photon.set('color', 'yellow')
    , 2000

)
