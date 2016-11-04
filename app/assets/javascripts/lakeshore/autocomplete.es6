// lakeshore/autocomplete.es6
export class AutocompleteControl {
  // initialize the provide HTMLElement with the jQuery select2 module
  // the initialize function assumes a single entity, or an array of entities that all get the same values.
  // but select2 needs to be passed an array of unique values.
  initialize(el) {
    $(el).select2({
      placeholder: ( el.dataset.placeholder !== undefined && el.dataset.placeholder.length > 0 ) ? el.dataset.placeholder : 'Search for a Resource by title, ID or main ref. number...',
      minimumInputLength: ( el.dataset.minchars !== undefined && el.dataset.minchars.length > 0 ) ? el.dataset.minchars : 3,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: ( el.dataset.endpoint !== undefined && el.dataset.endpoint.length > 0 ) ? el.dataset.endpoint :
            '/autocomplete',
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
        var data = { uid: element.data('uid'), label: element.data('label'), thumbnail: element.data('thumbnail'), main_ref_no: element.data('main_ref_number') }
        callback(data)
      },
      formatResult: this.formatAssetResult,
      formatSelection: this.formatAssetSelection,
      dropdownCssClass: 'bigdrop',
      allowClear: true,
      escapeMarkup: function (m) { return m }
    })
  }
  formatAssetResult(asset) {
    var image_tag = asset.thumbnail ? '      <img class="media-object" src="' + asset.thumbnail + '">' : ''
    var main_ref_number_tag = asset.main_ref_number ? '<span class="res_main_ref_no">&nbsp;(' + asset.main_ref_number + ')</span>' : ''
    var markup = '<div class="media">' +
                 '  <div class="media-left">' +
                 '    <a href="#">' + image_tag +
                 '    </a>' +
                 '  </div>' +
                 '  <div class="media-body">' +
                 '    <h4 class="media-heading">' + asset.uid + '</h4>' + asset.label +
                 main_ref_number_tag +
                 '  </div>' +
                 '</div>'
    return markup
  }

  formatAssetSelection(asset) {
    return '<span data-img="'+asset.thumbnail+'">' + asset.label + ' (' + asset.uid + ')' + '</span>'
  }
}
