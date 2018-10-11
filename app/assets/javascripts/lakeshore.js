// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
    $('.autocomplete-components').each(function (i) {
      Lakeshore.autocompleteControl(this);
    });
    $('.autocomplete_model').select2({
      theme: "classic",
      minimumResultsForSearch: Infinity
    });
    this.assetManager();
    this.assetWorkflow();
    this.formValidator();
  },
  autocompleteControl: function (element) {
    var ac = require('lakeshore/autocomplete');
    var controller = new ac.AutocompleteControl();
    controller.initialize(element);
  },

  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
  },

  assetManager: function () {
    var atr = require('lakeshore/asset_manager');
    var asset_manager = new atr.AssetManager('.am');
    asset_manager.initialize();
  },

  assetWorkflow: function () {
    var awf = require('lakeshore/asset_workflow');
    var asset_workflow = new awf.AssetWorkflow();
    asset_workflow.initialize();
  },

  formValidator: function () {
    var fv = require('lakeshore/form_validator');
    var form_validator = new fv.FormValidator($("#lakeshore-form-progress"));
    form_validator.initialize();
  },
};

Blacklight.onLoad(function () {
  Lakeshore.initialize();

  // Using Bootstrap's tab links won't work if they're outside of the tabs they're controlling.
  // Here we do it "manually"
  $('.tabfaker').on('click', function(event) {
    var metadata_tab = $("ul.nav-tabs li")[1];
    var files_tab = $("ul.nav-tabs li")[0];

    $("ul.nav-tabs li").removeClass("active");
    $("div.tab-content div").removeClass("active");

    if ($(this).attr("href") == "#metadata") {
      $(metadata_tab).addClass("active");
      $("div#metadata").addClass("active");
    }

    if ($(this).attr("href") == "#files"){
      $(files_tab).addClass("active");
      $("div#files").addClass("active");
    }
  });

});

// https://cits.artic.edu/redmine/issues/2338
$(function() {

    var star = $('table.representation_uris .aic-star-on');
    var star_tr = star.closest('tr');

    var table = star_tr.parent();
    table.prepend(star_tr);

    function unstar_all_stars() {
        $('.aic-star-on').toggleClass('aic-star-off aic-star-on');
    }

    function toggle_clicked_star(clicked_nonstar) {
        clicked_nonstar.toggleClass('aic-star-off aic-star-on');
    }

    function move_star_to_top(parent_table, current_row) {
        parent_table.prepend(current_row);
    }

    $("table.representation_uris").on('click', '.aic-star-off', function(){
        var uri_input = $(this).parent().next().next().find("input");
        var new_uri = uri_input.val();
        $('.preferred_representation').attr('value', new_uri);
        var current_row = $(this).closest('tr');
        var parent_table = current_row.parent();
        unstar_all_stars();
        toggle_clicked_star($(this));
        move_star_to_top(parent_table, current_row);
    });
});

$(function() {
    $('#deleteAsset').on('hidden.bs.modal', function () {
        $('.single-asset-delete').removeClass('single-asset-delete');
    })

    var check_not_needed = false;
    $('.check-if-preferred').on("click", function(e) {
        // get original anchor, so we can trigger a click again after we set the bypass flag
        var originalAtag = $(this);

        // add a class to the element to signify the active asset trying to be deleted
        originalAtag.addClass("single-asset-delete");

        // if this function has already run, just return
        if (check_not_needed) {
            return; // let the event bubble away
        }

        // stop normal activity
        e.preventDefault();
        e.stopPropagation();

        // get id of asset involved
        var assetId = $(this).data("asset-id");

        // make a call to the server and see if the asset is a preferred of any CR's
        $.getJSON( "/assets/" + assetId + "/relationships/", function(results) {
            var numberOfResults = results.length;

            if (numberOfResults > 0) {

                // get tbody element
                var tbodyRef = document.getElementById('deleteAsset').getElementsByTagName('tbody')[0];

                // reset rows of tbody
                tbodyRef.innerHTML = "";

                results.forEach(function(element) {

                    // Insert a row in the table at the last row
                    var newRow = tbodyRef.insertRow(tbodyRef.rows.length);

                    // Insert a cell in the row at index 0
                    var newCell = newRow.insertCell(0);

                    // Append an anchor to the cell
                    var newAnchor = document.createElement("a");
                    newAnchor.setAttribute('href', element.edit_path);
                    newAnchor.setAttribute('target', '_blank');
                    newAnchor.innerHTML = element.pref_label_tesim;
                    newCell.appendChild(newAnchor);
                });

                $("#deleteAsset").modal();

            } else {
                check_not_needed = true; // set bypass flag if we already got this far
                originalAtag.trigger('click');
            }
        });
    });
});
