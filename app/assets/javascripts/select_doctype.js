// Controls the display of the Document type when creating new assets

(function( $ ){
  $.fn.selectDoctype = function( options ) {

    var select_doctype = {

      getAssetType: function(data, assetType) {
        var totalDocTypes;
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/StillImage') {
          totalDocTypes = data.asset_types.StillImage.doctypes;
        }
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/Text') {
          totalDocTypes = data.asset_types.Text.doctypes;
        }
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/Dataset') {
          totalDocTypes = data.asset_types.Dataset.doctypes;
        }
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/MovingImage') {
          totalDocTypes = data.asset_types.MovingImage.doctypes;
        }
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/Sound') {
          totalDocTypes = data.asset_types.Sound.doctypes;
        }
        if (assetType == 'http://definitions.artic.edu/ontology/1.0/type/Archive') {
          totalDocTypes = data.asset_types.Archive.doctypes;
        }
        return totalDocTypes;
      },

      getListValues: function(docType, totalDocTypes) {
        var totalSubtypes;
        for (var i = 0; i < totalDocTypes.length; i++) {
          if (docType == totalDocTypes[i]['value']) {
            totalSubtypes = totalDocTypes[i].subtypes;
          }
        }
        return totalSubtypes;
      },

      makeDropdown: function(selectListForm, selection, totalOptions) {
        console.log(" make dropdown with selection: ", selection, "totalOptions: ", totalOptions)
        if (totalOptions === undefined){
          return
        } else {
          if (totalOptions.length) {
            for (var i = 0; i < totalOptions.length; i++) {
              var dataVals = [];
              var selected;
              dataVals = totalOptions[i];

              if (selection == dataVals['value']) {
                selectListForm.append("<option selected value='" + dataVals['value'] + "' label='" + dataVals['label'] + "'>" + dataVals['label'] + "</option>");
              } else {
                selectListForm.append("<option value='" + dataVals['value'] + "' label='" + dataVals['label'] + "'>" + dataVals['label'] + "</option>");
              }
            }
          }
        }
      },
      documentSubType: function(model, term, option) {
        var html =
                  "<select class='select optional form-control form-control' " +
                    "name='"+model+"["+term+"]' " +
                    "id='"+model+"_"+term+"'></select>";
        if (option) {
          return $(html).append(option);
        } else {
          console.log("hello no option for subtype")
          return $(html).append("<option value=''>Please Select</option>");;
        }
      },

      getFormModel: function(form) {
        if (form.attr('id') == "new_batch_upload_item") {
            return "batch_upload_item"
        } else {
            return "generic_work"
        }
      }
    };
      return select_doctype;
  };

})( jQuery );


Blacklight.onLoad(function() {

  var select_doctype = $.fn.selectDoctype();
  var docTypeJson = "/lake_doctypes.json";
  var totalDocTypes;
  var totalSubtypes;
  var docType;

  var option = "<option value=''>Please Select</option>";
  var formModel = select_doctype.getFormModel($('form.simple_form'));

  var docTypeSelector = "#"+formModel+"_document_type_uri";
  var docTypeDivSelector = "div."+formModel+"_document_type_uri";

  var firstSubTypeSelector = "#"+formModel+"_first_document_sub_type_uri";
  var firstSubTypeDivSelector = "div."+formModel+"_first_document_sub_type_uri";

  var secondSubTypeSelector = "#"+formModel+"_second_document_sub_type_uri";
  var secondSubTypeDivSelector = "div."+formModel+"_second_document_sub_type_uri";

  var assetTypeSelector = "#"+formModel+"_asset_type";

  //loading json and creating doctype list
  $.getJSON(docTypeJson).done(function(data) {
    //select asset type, create doctype list
    var docTypeList = $(docTypeSelector);
    $("#asset_type_select").change(function() {
        var dropdown = $(this);
        docTypeList.html("");
        $( firstSubTypeSelector ).remove();
        $( secondSubTypeSelector ).remove();
        docTypeList.append("<option value=''>Please Select</option>");
        var key = dropdown.val();
        totalDocTypes = select_doctype.getAssetType(data, key);
        select_doctype.makeDropdown(docTypeList, null, totalDocTypes);
    });

    //okay. if you have no value in the sub select, you need to remove it from its corresponding data-uri attribute so that the server gets the correct information.
    //creating subtype list
    $(docTypeSelector).change(function() {
      console.log("hello change");
      if (totalDocTypes == null) {
        var assetType = $(assetTypeSelector).val();
        select_doctype.getAssetType(data, assetType);
      }
      var dropdown = $(this);
      $( firstSubTypeSelector ).remove();
      $( secondSubTypeSelector ).remove();
      var key = dropdown.val();
      if (key) {
        $(docTypeSelector).after(
          select_doctype.documentSubType(formModel,
            "first_document_sub_type_uri", option));
          var subTypeList = $(firstSubTypeSelector);
          totalSubtypes = select_doctype.getListValues(key, totalDocTypes);
          if (totalSubtypes && totalSubtypes.length > 0) {
            select_doctype.makeDropdown(subTypeList, null, totalSubtypes);
          } else {
            $(firstSubTypeSelector).remove();
            $(firstSubTypeDivSelector).attr('data-uri', '');
            // no subtypes, remove uri value.
            //uri values get removed, and not sent to server in params, but somehow do not update object.  .. solr-index??
          }
        } else {
          console.log("no doc type value, remove sub select?")
        }

        //creating subtype2 list
        $(firstSubTypeSelector).change(function() {
            var dropdown = $(this);
            $( secondSubTypeSelector ).remove();
            var key = dropdown.val();
            var totalSubtypes2;
            totalSubtypes2 = select_doctype.getListValues(key, totalSubtypes);
            if (totalSubtypes2) {
                $(firstSubTypeSelector).after(
                    select_doctype.documentSubType(formModel, "second_document_sub_type_uri", option)
                );
                var subTypeList2 = $(secondSubTypeSelector);
                select_doctype.makeDropdown(subTypeList2, null, totalSubtypes2);
            }
        });
    });

    //asset type already selected
    if ($(assetTypeSelector).val() && $(docTypeDivSelector).data('uri')) {

      var assetType = $(assetTypeSelector).val();
      docType = $(docTypeDivSelector).data('uri');
      docTypeList.html("");
      var totalDocTypes = select_doctype.getAssetType(data, assetType);
      select_doctype.makeDropdown(docTypeList, docType, totalDocTypes);
      var totalSubtypes = select_doctype.getListValues(docType,totalDocTypes);
      var validSubtype = false;
      $(totalSubtypes).each(function(){
        if (this.value == $(firstSubTypeDivSelector).data('uri')){
          validSubtype = true;
          console.log("hey, validSubtype: ", validSubtype );
        }
      });
      //console.log("is the uri value in the subtype list, in an item's value property?", $(firstSubTypeDivSelector).data('uri'));
      //if there is no subtypes list, don't draw the sub select, if the subtype is invalid make sure the subtype data-uri is empty also.

      if ( validSubtype == false ) {
        $(firstSubTypeDivSelector).attr('data-uri', '');
        $(firstSubTypeDivSelector).data('uri', '');
      }

      if (totalSubtypes !== undefined) {
        $(docTypeSelector).after(
            select_doctype.documentSubType(formModel,
              "first_document_sub_type_uri"));

        console.log("totalSubtypes: ", totalSubtypes);
        var subType = $(firstSubTypeDivSelector).data('uri');
        var subTypeList = $(firstSubTypeSelector);

        select_doctype.makeDropdown(subTypeList, subType, totalSubtypes);

        if ( $(secondSubTypeDivSelector).data('uri') ) {
          $(firstSubTypeSelector).after( select_doctype.documentSubType(formModel, "second_document_sub_type_uri"));

          var totalSubtypes2 = select_doctype.getListValues(subType, totalSubtypes);
          var subType2 = $(secondSubTypeDivSelector).data('uri');
          var subTypeList2 = $(secondSubTypeSelector);
                    select_doctype.makeDropdown(subTypeList2, subType2, totalSubtypes2);
        }
      }
    }
  });
});
