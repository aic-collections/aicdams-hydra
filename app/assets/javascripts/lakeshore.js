// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
    this.autocompleteControl(3, "/autocomplete");
  },

  autocompleteControl: function (length, endpoint) {
    var ac = require('lakeshore/autocomplete');
    var controller = new ac.AutocompleteControl();

    $('.base-terms')
      .find('input[class*="_representation_uris"],input[class*="_document_uris"]')
      .typeahead({
        minLength: length,
        highlight: true
      }, {
        name: 'aic-uids',
        source: controller.source(endpoint),
        display: controller.display,
        templates: {
          suggestion: controller.suggestion
        }
      });
  },

  // This is copied after Sufia.saveWorkControl
  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
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

