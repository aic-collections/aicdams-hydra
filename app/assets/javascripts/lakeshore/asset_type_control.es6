// re-use Sufia's UploadedFiles class to monitor uploaded files
import { UploadedFiles } from 'sufia/save_work/uploaded_files'
import { DeletedFiles } from 'lakeshore/deleted_files'

export class AssetTypeControl {
  /**
   * @param {jQuery} element the asset type select input
   */
  constructor(element) {
    this.element = element
    this.form = element.closest('form')
  }

  activate() {
    this.uploads = new UploadedFiles(this.form, () => this.disableSelect())
    this.deletes = new DeletedFiles(this.form, () => this.enableSelect())
  }

  disableSelect() {
    if (this.uploads.hasFiles)
      this.element.prop('disabled', true)
  }

  enableSelect() {
    if (this.deletes.lastFile) {
      this.element.removeProp('disabled')
    }
  }
}
