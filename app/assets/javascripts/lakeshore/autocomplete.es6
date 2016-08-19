export class AutocompleteControl {
  loadMatches(min_length, endpoint, cb) {
    return (evt) => {
      if (evt.target.value.length >= min_length) {
        $.getJSON(`${endpoint}?q=${evt.target.value}`, cb);
      }
    }
  }
}
