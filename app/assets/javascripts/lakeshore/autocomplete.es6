// lakeshore/autocomplete.es6
export class AutocompleteControl {

  // initialize the provide HTMLElement with the jQuery select2 module
  initialize(el, length, endpoint) {
    $(el).select2({
      placeholder: "Search for an asset",
      minimumInputLength: length,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: endpoint,
        dataType: 'json',
        data: function (term, page) {
          if ( $('#autocomplete_model').length > 0 ) {
            return { q: term, model: $('#autocomplete_model').val() }
          }
          else {
            return { q: term }
          }
        },
        results: function (data, page) {
          return { results: data }
        }
      },
      initSelection: function(element, callback) {
        var data = { uid: element.data('uid'), label: element.data('label'), thumbnail: element.data('thumbnail') }
        callback(data)
      },      
      formatResult: this.formatAssetResult,
      formatSelection: this.formatAssetSelection,
      dropdownCssClass: "bigdrop",
      allowClear: true,
      escapeMarkup: function (m) { return m }
    })
  }

  formatAssetResult(asset) {
    var markup = '<div class="media">' +
                 '  <div class="media-left">' +
                 '    <a href="#">' +
                 '      <img class="media-object" src="' + asset.thumbnail + '">' +
                 '    </a>' +
                 '  </div>' +
                 '  <div class="media-body">' +
                 '    <h4 class="media-heading">' + asset.uid + '</h4>' + asset.label +
                 '  </div>' +
                 '</div>'; 
    return markup
  }

  formatAssetSelection(asset) {
    return '<span data-img="'+asset.thumbnail+'">' + asset.label + ' (' + asset.uid + ')' + '</span>'
  }
}
