// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
    this.autocompleteControl(2, "/autocomplete");
  },

  autocompleteControl: function (length, endpoint) {
    var ac = require('lakeshore/autocomplete');
    var controller = new ac.AutocompleteControl();

    // a convenience function for passing to jQuery.each
    var init = function () { controller.initialize(this, length, endpoint); }

    // a fn to add these event handlers to the correct DOM elements.
    var propogate = function () {
      var parent = $(this).parent().parent().parent();

      // re-queue this event handler so that the target DOM element has had a chance
      // to be created.
      setTimeout(function() {
        $(parent).find('input').last().each(init);
        // recurse, so that this handler is added to the new DOM element
        $('.base-terms button.add').on('click', propogate);
      }, 0);
    };

    $('.base-terms')
      .find('input[class*="_representation_uris"],input[class*="_document_uris"]')
      .each(init);

    // add the autocomplete control to the newly created DOM elements
    $('.base-terms button.add').on('click', propogate);
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

