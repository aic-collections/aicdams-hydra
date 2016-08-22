// Controls the display of the "Files" tab when creating new assets

function disableFilesTab() {
  var tab = $('ul[role="tablist"] li')[1]
  var buttonbar = $('.fileupload-buttonbar');
  $(tab).addClass("disabled");
  $(buttonbar).hide();
}

function enableFilesTab() {
  var tab = $('ul[role="tablist"] li')[1]
  var buttonbar = $('.fileupload-buttonbar');
  $(tab).removeClass("disabled");
  $(buttonbar).show();
}

Blacklight.onLoad(function() {

  // Disable the files tab when the page is loaded. It is only present for #new actions	
  if ($('select#asset_type_select').length) {
    if ($('select#asset_type_select option:selected').text() === "") {
      disableFilesTab();
    }
  }

  $('a[href="#files"]').on('click', function(evt) {
    if ($('select#asset_type_select').length) {
      if ($('select#asset_type_select option:selected').text() === "") {
        evt.preventDefault();
        return false;
      }
    }
  });

  $('select#asset_type_select').change(function(evt) {
    if (evt.target.selectedIndex > 0) {
      enableFilesTab();
      $('#hidden_asset_type').val($(evt.target.selectedOptions).val());
    }
    else {
      disableFilesTab();	
      $('#hidden_asset_type').val("");
    }
  });  

});