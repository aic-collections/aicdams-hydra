// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
    this.autocompleteControl(3, "/autocomplete");
    this.assetManager();
    this.assetWorkflow();
  },

  autocompleteControl: function (length, endpoint) {
    var ac = require('lakeshore/autocomplete');
    var controller = new ac.AutocompleteControl();
    controller.initialize('.autocomplete', length, endpoint);
  },

  // This is copied after Sufia.saveWorkControl
  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
  },

  assetManager: function () {
    var atr = require('lakeshore/asset_manager');
    var asset_manager = new atr.AssetManager('.am');
    asset_manager.initialize();
  },

  assetWorkflow: function () {
    var awf = require('lakeshore/asset_workflow');
    var asset_workflow = new awf.AssetWorkflow();
    asset_workflow.initialize();
  }
};

Blacklight.onLoad(function () {
  Lakeshore.initialize();
  if ( $('div.openseadragon-container').length && !$('div.openseadragon-canvas').length) {
    initOpenSeadragon();
  }
});

function initOpenSeadragon() {
  $('picture[data-openseadragon]').openseadragon();
}
