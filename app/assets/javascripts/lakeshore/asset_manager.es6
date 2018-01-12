// lakeshore/asset_manager
// Manages adding and removing assets from resources.

export class AssetManager {

  constructor(element) {
    this.manager = element
    this.data = null
  }

  // sets up listeners
  initialize() {
    let $this = this

    $('.am-add').on('click', function(event) {
      event.preventDefault()
      $this.data = $(this).data();
      var parent_div_class = $(this).closest("div").attr('class');
      $('table.'+$this.data.attribute).append($this.assetRow(parent_div_class));
      var sel = '.' + $this.data.attribute
      $(sel).select2('val', '')
    })

    $('.am').on('click', '.am-delete', function(event) {
      event.preventDefault()
      var parent_row = $(this).closest("tr");
      if ( parent_row.is(':first-child') == true )
        {
            $('.preferred_representation').attr('value', '');
        };
      $this.removeRow(this)
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
    input.val('')
    $(row).html($(input))
  }

  assetRow(parent_div) {
    var image_tag = this.selectedAssetImage ? '<img src="' + this.selectedAssetImage + '" />' : '';
    var pref_rep_star = '<div class="aic-star-off"></div>';

    var representations_html =
      '<tr>' +
        '<td>' + pref_rep_star + '</td>' +
        '<td>' + image_tag + '</td>' +
        '<td>' +
           this.selectedAssetText + this.hiddenInput +
        '</td>' +
        '<td><a href="#" class="btn btn-danger am-delete">- Remove</a></td>' +
      '</td>';

    var documentations_html =
        '<tr>' +
        '<td>' + image_tag + '</td>' +
        '<td>' +
        this.selectedAssetText + this.hiddenInput +
        '</td>' +
        '<td><a href="#" class="btn btn-danger am-delete">- Remove</a></td>' +
        '</td>';

    if (parent_div.indexOf("work_representation_uris") >= 0) {
        return representations_html;
    } else {
        return documentations_html;
    }
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
