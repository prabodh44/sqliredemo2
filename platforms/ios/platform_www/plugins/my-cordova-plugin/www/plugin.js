cordova.define("my-cordova-plugin.plugin", function(require, exports, module) {

var exec = require('cordova/exec');

var PLUGIN_NAME = 'SqliteConnect';

var SqliteConnect = {
  echo: function(phrase, cb) {
    exec(cb, null, PLUGIN_NAME, 'echo', [phrase]);
  },
  getDate: function(cb) {
    exec(cb, null, PLUGIN_NAME, 'getDate', []);
  }
};

module.exports = SqliteConnect;

});
