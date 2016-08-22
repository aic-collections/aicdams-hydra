export class AutocompleteControl {

  source(endpoint) {
      return (query, sync, async) => {
          $.getJSON(`${endpoint}?q=${query}`, async);
      }
  }

  suggestion(data) {
      return `<div>${data["prefLabel"][0]}</div>`;
  }

  display(data) {
      return data["uri"][0];
  }
}
