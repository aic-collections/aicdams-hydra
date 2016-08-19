export class DeletedFiles {
  // Monitors the form and runs the callback if the delete button in the fileupload is clicked
  constructor(form, callback) {
    this.form = form
    $('#fileupload').on('click', '.delete', callback)
  }

  get lastFile() {
    let fileField = this.form.find('input[name="uploaded_files[]"]')
    return fileField.size() == 1
  }
}
