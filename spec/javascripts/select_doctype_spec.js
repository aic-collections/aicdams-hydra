describe("Selecting document types", function() {
  select_doctype = $.fn.selectDoctype();

  it("loads selectDoctype", function() {
    expect(select_doctype.toString()).toEqual('[object Object]');
  });

  describe("documentSubType", function() {
    it("returns a select for a single upload, without an option", function() {
      var html = select_doctype.documentSubType("generic_work", "first_document_sub_type_uri");
      expect($(html).attr('id')).toEqual("generic_work_first_document_sub_type_uri");
      expect($(html).html()).toEqual("");
    });

    it("returns a select for a single upload, with an option", function() {
      var option = '<option value=""></option>';
      var html = select_doctype.documentSubType("generic_work", "first_document_sub_type_uri", option);
      expect($(html).attr('id')).toEqual("generic_work_first_document_sub_type_uri");
      expect($(html).html()).toEqual(option);
    });

    it("returns a select for a batch upload", function() {
      var html = select_doctype.documentSubType("batch_upload_item", "first_document_sub_type_uri");
      expect($(html).attr('id')).toEqual("batch_upload_item_first_document_sub_type_uri")
    });
  });

  describe("getFormModel", function() {
    it("returns the parameterized model name with the new asset form", function() {
      var form = $('<form class="simple_form new_generic_work" id="new_generic_work"></form>')
      expect(select_doctype.getFormModel(form)).toEqual("generic_work")
    });
    it("returns the parameterized model name with the edit asset form", function() {
      var form = $('<form class="simple_form edit_generic_work" id="edit_generic_work_SI-378144"></form>')
      expect(select_doctype.getFormModel(form)).toEqual("generic_work")
    });
    it("returns the parameterized model name with the batch create form", function() {
      var form = $('<form class="simple_form new_batch_upload_item" id="new_batch_upload_item"></form>')
      expect(select_doctype.getFormModel(form)).toEqual("batch_upload_item")
    });  
  });

});
