// Generated by CoffeeScript 1.10.0
(function() {
  var Photon, Promise, Spark, fs;

  Spark = require("spark");

  Promise = require("promise");

  fs = require("fs");

  Photon = (function() {
    Photon.photon = null;

    function Photon() {
      Photon.photon = null;
      this.ref = 'fisk';
    }

    Photon.prototype.connect = function() {
      return new Promise(function(resolve, reject) {
        var credentials;
        credentials = fs.readFileSync("credentials.json", "utf8");
        credentials = JSON.parse(credentials.photon);
        Spark.login(credentials);
        return Spark.on('login', function() {
          var devices;
          devices = Spark.listDevices();
          return devices.then(function(devices) {
            Photon.photon = devices[0];
            return resolve("connected");
          }, function(err) {
            return reject(err);
          });
        });
      });
    };

    Photon.prototype.get = function(property) {
      return new Promise(function(resolve, reject) {
        return Photon.photon.getVariable(property, function(err, data) {
          if (err != null) {
            return reject(err);
          } else {
            return resolve(data);
          }
        });
      });
    };

    Photon.prototype.set = function(property, value) {
      return new Promise(function(resolve, reject) {
        value = value.toString();
        return Photon.photon.callFunction('set', property + ":" + value, function(err, data) {
          if (err != null) {
            return reject(err);
          } else {
            return resolve(data);
          }
        });
      });
    };

    Photon.prototype["do"] = function(action, times) {
      return new Promise(function(resolve, reject) {
        if (times == null) {
          times = 1;
        }
        times = times.toString();
        return Photon.photon.callFunction('do', action + ":" + times, function(err, data) {
          if (err != null) {
            return reject(err);
          } else {
            return resolve(data);
          }
        });
      });
    };

    Photon.prototype.on = function(event, callback) {
      return Photon.photon.onEvent(event, callback);
    };

    return Photon;

  })();

  module.exports = Photon;

}).call(this);
