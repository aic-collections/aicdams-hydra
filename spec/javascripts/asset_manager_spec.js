describe("AssetManager", function() {
  var manager = null
  beforeEach(function() {
    loadFixtures('autocomplete.html');
    var am = require('lakeshore/asset_manager');
    manager = new am.AssetManager();
    manager.data = { "name": "name", "model": "model", "attribute": "uris" }    
  })

  it("renders a hidden input", function() {
    expect(manager.hiddenInput).toEqual('<input value="asset-uri" id="model_uris" name="name" type="hidden" />')
  });

  it("renders an asset row", function() {
    var html = manager.assetRow
    expect(html).toContain("selected display")
    expect(html).toContain("thumbnail-path")
  });
});
