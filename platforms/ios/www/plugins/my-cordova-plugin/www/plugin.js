cordova.define("my-cordova-plugin.plugin", function (require, exports, module) {

  var exec = require('cordova/exec');

  var PLUGIN_NAME = 'SqliteConnect';

  var SqliteConnect = {
    echo: function (phrase, cb) {
      exec(cb, null, PLUGIN_NAME, 'echo', [phrase]);
    },
    getDate: function (cb) {
      exec(cb, null, PLUGIN_NAME, 'getDate', []);
    },
    createTable: function (cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionCreateTable', []);
    },
    insertData: function (query, cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionInsertIntoTable', [query]);
    },
    updateData: function (cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionUpdateIntoTable', [query]);
    },
    deleteData: function (cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionDeleteFromTable', [query]);
    },
    readData: function (query, cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionReadFromTable', [query]);
    },
    createDB: function (cb) {
      exec(cb, null, PLUGIN_NAME, 'ActionDatabaseInitialize', []);
    }
  };

  module.exports = SqliteConnect;

});
