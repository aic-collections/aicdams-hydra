describe("new_asset.js", function() {

  describe("a single upload form", function() {
    it("updates the value of the hidden asset type field", function() {
      loadFixtures('single_form.html');
      var hidden_asset_type = $('#hidden_asset_type');
      var asset_type_select = $('select#asset_type_select');

      expect(hidden_asset_type.attr('value')).toEqual("");
      asset_type_select.val('still_image_type').trigger('change');
      hidden_asset_type.val(asset_type_select.val());
      expect(hidden_asset_type.attr('value')).toEqual("still_image_type");
    });
  });

  describe("a batch upload form", function() {
    it("updates the value of the hidden asset type field", function() {
      loadFixtures('batch_form.html');
      var hidden_asset_type = $('#hidden_asset_type');
      var asset_type_select = $('select#asset_type_select');

      expect(hidden_asset_type.attr('value')).toEqual("");
      asset_type_select.val('still_image_type').trigger('change');
      hidden_asset_type.val(asset_type_select.val());
      expect(hidden_asset_type.attr('value')).toEqual("still_image_type");
    });
  });  
});
