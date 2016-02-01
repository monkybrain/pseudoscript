Util = require "./../src/core/util"

Globals = {}
Globals['hue'] = 23

Util.math.multiply [Globals['hue'], 3]
.then (response) -> console.log response
