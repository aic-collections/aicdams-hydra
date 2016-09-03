describe("autocomplete.es6", function() {
  var controller = null;
  var asset = null;
  beforeEach(function() {
    var ac = require('lakeshore/autocomplete');
    controller = new ac.AutocompleteControl();
    asset = { "uid": "asset-uid", "label": "asset-label", "id": "fedora-url", "thumbnail": "asset-thumbnail" }
  });

  it("formats the selectd asset", function() {
    var formattedSelection = '<span data-img="asset-thumbnail">asset-label (asset-uid)</span>'
    expect(controller.formatAssetSelection(asset)).toEqual(formattedSelection);
  });

  it("formats the asset search result", function() {
    var html = controller.formatAssetResult(asset);
    expect($(html).find('.media-object').attr('src')).toEqual(asset.thumbnail);
    expect($(html).find('.media-heading').text()).toEqual(asset.uid);
    expect($(html).find('.media-body').text()).toContain(asset.label);
  });
});
