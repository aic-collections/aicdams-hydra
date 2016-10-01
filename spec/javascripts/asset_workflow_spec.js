describe("Asset workflow", function() {
  var asset_workflow = null
  beforeEach(function() {
    loadFixtures('asset_workflow.html');
    var awf = require('lakeshore/asset_workflow');
    asset_workflow = new awf.AssetWorkflow();
    asset_workflow.initialize();
  })

  describe("when the new form is first loaded", function() {
    it("marks the description tab disabled", function() {
      expect(asset_workflow.tab).toHaveClass("disabled")
    })
    it("hides the files button and dropzone", function() {
      expect(asset_workflow.buttonbar).toBeHidden()
    })
  })

  describe("assetTypeSelector", function() {
    it("returns the css class for the type of asset", function() {
      asset_workflow.type = "http://definitions.artic.edu/ontology/1.0/type/StillImage"
      expect(asset_workflow.assetTypeSelector).toEqual(".asset-image")
      asset_workflow.type = "http://definitions.artic.edu/ontology/1.0/type/Text"
      expect(asset_workflow.assetTypeSelector).toEqual(".asset-text")
    })
  })
})
