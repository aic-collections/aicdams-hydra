// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
  },

  // This is copied after Sufia.saveWorkControl
  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
  },

};

Blacklight.onLoad(function () {
  Lakeshore.initialize();

});
