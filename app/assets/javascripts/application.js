// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require turbolinks
// Required by Blacklight
//= require blacklight/blacklight

// Load Javascript < ES6
//= require batch_edit
//= require blacklight_gallery
//= require openseadragon
//= require select_doctype

// Load Sufia and ES6 Javascript
//= require sufia
//= require lakeshore
//= require lakeshore/asset_manager
//= require lakeshore/asset_type_control
//= require lakeshore/autocomplete
//= require lakeshore/deleted_files
//= require lakeshore/asset_workflow

// Set upload limits
// Overrides defaults in CurationConcerns uploader.js
// 1 GB  max file size 
max_file_size = 1073741824;
max_file_size_str = "1 GB";
// 100 GB max total upload size
max_total_file_size = 107374182400;
max_total_file_size_str = "100 GB";
