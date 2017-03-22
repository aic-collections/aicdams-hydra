// Controls the display of the Document type when creating new assets

(function( $ ){
  $.fn.selectDoctype = function( options ) {

    var select_doctype = {
      //TODO: this would be nicer as a case statement with a regex pattern to match against, instead of repeating part of the url each time.
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
            selectListForm.append("<option value=''>Please Select</option>");
          }
        }
      },
      createSecondSubtype: function(firstsubtype){
        this.selectedSecondSubtype = false;
        var dropdown = $(firstsubtype);
        var key = dropdown.val();
        var allDocTypes = this.getAssetType(this.lake_doctypes, this.asset_type);

        var totalSubtypes2;
        totalSubtypes = this.getListValues(this.doctype_val, allDocTypes);
        totalSubtypes2 = this.getListValues(key, totalSubtypes);

        if (totalSubtypes2) {
          $(firstsubtype).after(
            this.documentSubType(this.formModel, "second_document_sub_type_uri", "<option value=''>Please Select</option>").hide());
          var subTypeList2 = $(this.secondSubTypeSelector);
          this.makeDropdown(subTypeList2, null, totalSubtypes2);
          $(this.secondSubTypeSelector).show();
          $(this.secondSubTypeSelector).change(function(){
            if ($(this).val()) {
              select_doctype.selectedSecondSubtype = true;
            }
          });
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
          return $(html);
        }
      },

      hiddenSubType: function(model, term, docTypeSelector, className){
        var html = "<input class='"+className+" form-control form-control' " +
          "name='"+model+"["+term+"]' " +
          "id='"+model+"_"+term+"' type='hidden'></input>";
        $(docTypeSelector).after(html);
      },

      getFormModel: function(form) {
        if (form.attr('id') == "new_batch_upload_item") {
          return "batch_upload_item"
        } else {
          return "generic_work"
        }
      },

      selectedSubtype: false,
      selectedSecondSubtype: false,
      lake_doctypes: "",
      doctype_val: "",
      validateSubTypes: function(){
        if (this.selectedSubtype == true){
          //remove sub clear
          $('.first_invalid_subtype').remove();
        }
        if (this.selectedSecondSubtype == true){
          //remove subSub clear
          $('.second_invalid_subtype').remove();
        } else {
          // send empty unless you have a value, to clear
          var html = "<input class='second_invalid_subtype form-control form-control' " +
            "name='"+this.formModel+"[second_document_sub_type_uri]' " +
            "id='"+this.formModel+"_second_document_sub_type_uri' type='hidden'></input>";
          $(html).appendTo('form.simple_form');
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

  $('form.simple_form').submit(function(){
    select_doctype.validateSubTypes();
  });

  //loading json and creating doctype list
  $.getJSON(docTypeJson).done(function(data) {
    //select asset type, create doctype list
    select_doctype.lake_doctypes = data;
    select_doctype.asset_type = $(assetTypeSelector).val();
    select_doctype.doctype_val =  $(docTypeDivSelector).data('uri');
    select_doctype.firstSubTypeSelector = firstSubTypeSelector;
    select_doctype.secondSubTypeSelector = secondSubTypeSelector;
    select_doctype.formModel = formModel;
    var docTypeList = $(docTypeSelector);
    $("#asset_type_select").change(function() {
        var dropdown = $(this);
        docTypeList.html("");
        $( firstSubTypeSelector ).remove();
        $( secondSubTypeSelector ).remove();
        docTypeList.append("<option value=''>Please Select</option>");
        var key = dropdown.val();
        select_doctype.asset_type = key;
        totalDocTypes = select_doctype.getAssetType(data, key);
        select_doctype.makeDropdown(docTypeList, null, totalDocTypes);
    });

    $(docTypeSelector).change(function() {
      if (totalDocTypes == null) {
        var assetType = $(assetTypeSelector).val();
        select_doctype.getAssetType(data, assetType);
      }
      var dropdown = $(this);
      $(firstSubTypeSelector).remove();
      $(secondSubTypeSelector).remove();
      select_doctype.selectedSubtype = false;
      select_doctype.selectedSecondSubtype = false;
      var key = dropdown.val();
      select_doctype.doctype_val = key;
      //info services
      if (key) {
        $(docTypeSelector).after(
          select_doctype.documentSubType(formModel,
            "first_document_sub_type_uri", option).hide());
          var subTypeList = $(firstSubTypeSelector);
          totalSubtypes = select_doctype.getListValues(key, totalDocTypes);
          if ((totalSubtypes) && (totalSubtypes.length > 0)){
            subTypeList.show();
            select_doctype.makeDropdown(subTypeList, null, totalSubtypes);
            $(firstSubTypeSelector).change(function(){
              $(secondSubTypeSelector).remove();
              if ($(this).val()) {
                select_doctype.selectedSubtype = true;
              }
              select_doctype.createSecondSubtype(this);
            });
          }
        }
    });

    //asset type already selected

    if ($(assetTypeSelector).val() && $(docTypeDivSelector).data('uri')) {
      var assetType = $(assetTypeSelector).val();
      docType = $(docTypeDivSelector).data('uri');

      docTypeList.html("");

      var totalDocTypes = select_doctype.getAssetType(data, assetType);
      select_doctype.makeDropdown(docTypeList, docType, totalDocTypes);
      totalSubtypes = select_doctype.getListValues(docType,totalDocTypes);

      // watch out, you could have some invalid types

      var validSubtype = false;
      var subType;
      $(totalSubtypes).each(function(){
        if (this.value == $(firstSubTypeDivSelector).data('uri')){
          validSubtype = true;
          select_doctype.selectedSubtype = true;
          $('.first_invalid_subtype').remove();
          subType = $(firstSubTypeDivSelector).data('uri');
        }
      });

      if ( validSubtype == false ) {
        select_doctype.hiddenSubType(formModel, "first_document_sub_type_uri", docTypeSelector, "first_invalid_subtype");
      }

      // assume secondSubtype is false on page load, then check all of these criteria to determine truth.
      var validSubSubtype = false;
      if ( $(secondSubTypeDivSelector).data('uri') && $(firstSubTypeDivSelector).data('uri') && totalSubtypes ){
        var totalSubtypes2 = select_doctype.getListValues(subType, totalSubtypes);

        $(totalSubtypes2).each(function(){
          if (this.value == $(secondSubTypeDivSelector).data('uri')){
            validSubSubtype = true;
            $('.second_invalid_subtype').remove();
            select_doctype.selectedSecondSubtype = true;
          }
        });
      }

      if ( validSubSubtype == false ) {
        select_doctype.hiddenSubType(formModel, "second_document_sub_type_uri", firstSubTypeDivSelector, "second_invalid_subtype");
      }

      //make sub dropdown

      if ( $(firstSubTypeDivSelector).data('uri') && validSubtype ) {

        $(docTypeSelector).after( select_doctype.documentSubType(formModel,
              "first_document_sub_type_uri"));

        var subTypeList = $(firstSubTypeSelector);
        select_doctype.makeDropdown(subTypeList, subType, totalSubtypes);

        $(firstSubTypeSelector).change(function(){
          select_doctype.selectedSubtype = false;
          select_doctype.selectedSecondSubtype = false;
          if ($(this).val()) {
            select_doctype.selectedSubtype = true;
          }
          $(secondSubTypeSelector).remove();
          select_doctype.createSecondSubtype(this);
        });

        //if the page loads with three levels of doc types: doc, sub, and second sub && it is valid

        if ( $(secondSubTypeDivSelector).data('uri') && validSubSubtype ) {
          $(firstSubTypeSelector).after( select_doctype.documentSubType(formModel, "second_document_sub_type_uri"));
          var subType2 = $(secondSubTypeDivSelector).data('uri');
          var subTypeList2 = $(secondSubTypeSelector);

          select_doctype.makeDropdown(subTypeList2, subType2, totalSubtypes2);
        }
      }
    }
  });
});
