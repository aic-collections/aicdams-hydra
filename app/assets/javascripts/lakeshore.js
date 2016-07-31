// lakeshore.js
Lakeshore = {
  initialize: function () {
    this.assetTypeControl();
  },

  // This is copied after Sufia.saveWorkControl
  assetTypeControl: function () {
    var at = require('lakeshore/asset_type_control');
    new at.AssetTypeControl($("#asset_type_select")).activate();
  },

};

Blacklight.onLoad(function () {
  Lakeshore.initialize();

});

$(function() {
    if($('#osd_modal_bg').length) {
        var dl_url = $('.img-responsive').closest('a').attr('href');
        var viewer = OpenSeadragon({
            id: "osd_canvas",
            //prefixUrl: "/images/osd/",
            tileSources: {
                type: 'image',
                url: dl_url,
                crossOriginPolicy: 'Anonymous',
                ajaxWithCredentials: false
            }
        });

        $('.img-responsive').on('click', function(e) {
            $('#osd_modal_bg').show();
            return false;
        });

        $('#osd_modal_bg').on('click', function(e) {
            e.stopPropagation();
            $(this).hide();
        });
    }
});
