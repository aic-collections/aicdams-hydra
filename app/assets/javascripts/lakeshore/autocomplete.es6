// lakeshore/autocomplete.es6
export class AutocompleteControl {
  // initialize the provided HTMLElements with the jQuery select2 module
  initialize(el) {
    var elem = $(el).find('.autocomplete')
    elem.select2({
      placeholder: ( elem.data('placeholder') !== undefined && elem.data('placeholder').length > 0 ) ? elem.data('placeholder') : 'Search for a Resource by title, ID or main ref. number...',
      minimumInputLength: ( elem.data('minchars') !== undefined && elem.data('minchars').length > 0 ) ? elem.data('minchars') : 3,
      ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
        url: ( elem.data('endpoint') !== undefined && elem.data('endpoint').length > 0 ) ? elem.data('endpoint') :
          '/autocomplete',
        dataType: 'json',
        data: function (term, page) {
          var model_select = $(el).find('.autocomplete_model')[1]
          if ( $(model_select).length > 0 ) {
            return { q: term, model: $(model_select).val() }
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
      var spanElement = document.createElement('span');
      spanElement.dataset.publishing = asset.publishing;
      spanElement.dataset.visibility = asset.visibility;
      spanElement.dataset.showPath = asset.show_path;
      spanElement.dataset.uid = asset.uid;
      spanElement.dataset.img = asset.thumbnail;
      spanElement.dataset.mainRefNumber = asset.main_ref_number ? asset.main_ref_number : '';
      spanElement.innerHTML = asset.label + ' (' + asset.uid + ')';
      return spanElement.outerHTML;
      }
}
