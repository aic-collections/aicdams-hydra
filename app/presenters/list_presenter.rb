class ListPresenter
  include Hydra::Presenter

  Struct.new("ListItemPresenter", :pref_label, :description, :id, :deletable?)

  def to_s
    model.pref_label
  end

  delegate :members, to: :model

  def member_list
    list = []
    members.each do |m|
      list << Struct::ListItemPresenter.new(m.pref_label, member_description(m), m.id, deletable?(m))
    end
    list
  end

  private

    def model
      @model ||= to_model
    end

    def member_description(item)
      return "No description available" if item.description.empty?
      item.description.join("<br />")
    end

    def deletable?(item)
      StatusType.active.id != item.id
    end
end
