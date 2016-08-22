// lakeshore/autocomplete.es6
export class AutocompleteControl {

  // initialize the provide HTMLElement with a jQuery autocomplete module
  initialize(el, length, endpoint) {
    $(el).autocomplete({
        minLength: length,
        source: (req, res) => {
            $.getJSON(endpoint, {q: req.term}, function(data) {
              // map the JSON structure into a format usable for jQuery.autocomplete
              res(data.map((x) => ({label: `${x.uid} (${x.prefLabel})`, value: x.uri })));
            });
          },
        focus: () => false,
        complete: () => $('.ui-autocomplete-loading').removeClass("ui-autocomplete-loading")
    })
  }
}
