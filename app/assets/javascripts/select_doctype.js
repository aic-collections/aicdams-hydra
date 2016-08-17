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
				if (totalOptions.length) {
					for (var i = 0; i < totalOptions.length; i++) {
						var dataVals = [];
						var selected;
						dataVals = totalOptions[i];
						selectListForm.append("<option value=" + dataVals['value'] + " label=" + dataVals['label'] + ">" + dataVals['label'] + "</option>");
						if (selection == dataVals['value']) {
							selected = i;
							selectListForm.prop('selectedIndex', selected);
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
				}
				else {
			    return html;
				}
			},

			getFormModel: function(form) {
        if (form.attr('id') == "new_batch_upload_item") {
        	return "batch_upload_item"
        }
        else {
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

	var option = "<option value=''></option>";
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
		
			
		//creating subtype list
		$(docTypeSelector).change(function() {
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
					select_doctype.documentSubType(formModel, "first_document_sub_type_uri", option)
				);
				var subTypeList = $(firstSubTypeSelector);
				totalSubtypes = select_doctype.getListValues(key, totalDocTypes);
				select_doctype.makeDropdown(subTypeList, null, totalSubtypes);
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
			
			if ($(firstSubTypeDivSelector).data('uri')) {
				$(docTypeSelector).after(
				  select_doctype.documentSubType(formModel, "first_document_sub_type_uri")
				);
				var totalSubtypes = select_doctype.getListValues(docType, totalDocTypes);
				var subType = $(firstSubTypeDivSelector).data('uri');
				var subTypeList = $(firstSubTypeSelector);
				
				select_doctype.makeDropdown(subTypeList, subType, totalSubtypes);
				
				if ($(secondSubTypeDivSelector).data('uri')) {
					$(firstSubTypeSelector).after(
					  select_doctype.documentSubType(formModel, "second_document_sub_type_uri")
					);
					
					var totalSubtypes2 = select_doctype.getListValues(subType, totalSubtypes);
					var subType2 = $(secondSubTypeDivSelector).data('uri');
					var subTypeList2 = $(secondSubTypeSelector);
					select_doctype.makeDropdown(subTypeList2, subType2, totalSubtypes2);
				}
			}
		}
		
	});
});
