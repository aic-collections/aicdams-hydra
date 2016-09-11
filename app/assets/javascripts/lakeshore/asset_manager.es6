// lakeshore/asset_manager
// Manages adding and removing assets from resources

export class AssetManager {

  constructor(element) {
    this.manager = element
    this.data = null
  }

  // sets up listeners
  initialize() {
    let $this = this;

    $('.am-add').on('click', function(event) {
      event.preventDefault()
      $this.data = $(this).data()
      $('table.'+$this.data.attribute).append($this.assetRow)
    })

    $('.am').on('click', '.am-delete', function(event) {
      event.preventDefault()
      $this.removeRow(this);
    })
  }

  removeRow(selector) {
    var table = $(selector).closest('table')
    var row = $(selector).closest('tr')
    if ( $(table).find('tr').length == 1 ) {
      this.nullInput(row)
    }
    else {
      $(row).remove()
    }
  }

  // When all assets are deleted, we have to send an empty array so the form
  // processes the deletions.
  nullInput(row) {
    var input = $(row).find('input')
    input.val("")
    $(row).html($(input))
  }

  get assetRow() {
    var image_tag = this.selectedAssetImage ? '<img src="' + this.selectedAssetImage + '" />' : ''
    var html =
      '<tr>' +
        '<td>' + image_tag + '</td>' +
        '<td>' +
           this.selectedAssetText + this.hiddenInput +
        '</td>' +
        '<td><a href="#" class="btn btn-danger btn-xs am-delete">Remove</a></td>' +
      '</td>'
    return html
  }

  // Input inserted when a asset is selected
  get hiddenInput() {
    var id = this.data.model + '_' + this.data.attribute
    return '<input value="'+this.selectedAssetUti+'" id="'+id+'" name="'+this.data.name+'" type="hidden" />' 
  }

  get selectedAssetText() {
    return $('.'+this.data.attribute).find('.select2-chosen').text()
  }

  get selectedAssetImage() {
    return $('.'+this.data.attribute).find('.select2-chosen').find('span').data().img
  }

  get selectedAssetUti() {
    return $('input.autocomplete.'+this.data.attribute).val()
  }

}
