// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
    this.autocompleteControl(3, "/autocomplete");
  },

  autocompleteControl: function (length, endpoint) {
    var ac = require('lakeshore/autocomplete');
    var controller = new ac.AutocompleteControl();
    $('.base-terms input').on('keyup', this.debounce(
      controller.loadMatches(length, endpoint, this.autocompleteHandler), 250));
  },

  autocompleteHandler: function (data) {
    console.log(data);
  },

  // This is copied after Sufia.saveWorkControl
  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
  },

  // throttle fn calls
  debounce: function(fn, wait) {
    var timeout;
    return function() {
      var context = this, args = arguments;
      var later = function() {
        timeout = null;
        fn.apply(context, args);
      }
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    }
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

