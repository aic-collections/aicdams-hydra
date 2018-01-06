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
    function unstar_all_stars() {
        $('.fa-star').toggleClass('fa-star-o fa-star');
    }

    function toggle_clicked_star(clicked_nonstar) {
        clicked_nonstar.toggleClass('fa-star-o fa-star');
    }

    function move_star_to_top(parent_table, current_row) {
        parent_table.prepend(current_row);
    }

    $("table.representation_uris").on('click', '.fa-star-o', function(){
        var $this = $(this)
        var current_row = $this.closest('tr');
        var parent_table = current_row.parent();
        unstar_all_stars();
        toggle_clicked_star($this);
        move_star_to_top(parent_table, current_row);
    });
});