# frozen_string_literal: true
class ListPresenter
  include Hydra::Presenter

  def to_s
    model.pref_label
  end

  def selector
    "#{model.pref_label.parameterize}_list"
  end

  delegate :members, to: :model

  def member_list
    list = []
    members.each do |m|
      list << ListItemPresenter.new(m)
    end
    list.sort { |a, b| a.pref_label <=> b.pref_label }
  end

  def description
    model.description.empty? ? "No description available" : model.description
  end

  def editable_by(user)
    user.can?(:edit, model)
  end

  class ListItemPresenter
    include Hydra::Presenter

    delegate :pref_label, :id, to: :model

    def to_s
      pref_label
    end

    def description
      model.description.empty? ? "No description available" : model.description
    end

    def deletable?
      ListItem.active_status.id != id
    end
  end
end
