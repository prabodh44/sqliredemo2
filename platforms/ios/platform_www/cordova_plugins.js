cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "my-cordova-plugin.plugin",
    "file": "plugins/my-cordova-plugin/www/plugin.js",
    "pluginId": "my-cordova-plugin",
    "clobbers": [
      "SqliteConnect"
    ],
    "runs": true
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "my-cordova-plugin": "1.0.0",
  "cordova-plugin-whitelist": "1.3.3"
};
// BOTTOM OF METADATA
});