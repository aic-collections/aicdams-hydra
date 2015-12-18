class ListItemEditForm
  include HydraEditor::Form

  self.model_class = ListItem
  self.terms = [:pref_label, :description]

  def editable?(term)
    return true unless term == :pref_label
    model.id != StatusType.active.id
  end
end
