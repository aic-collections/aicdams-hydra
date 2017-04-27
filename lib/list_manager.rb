# frozen_string_literal: true
# Manages the membership and types of lists that are used in Lakeshore.
# Using yaml files in the config directory, one list will be created per file.
# If the list or any of its members already exist, then it will not be altered.
class ListManager
  attr_reader :source

  # @param [String] file path to the yaml file
  def initialize(file)
    @source = YAML.load_file(file)
  end

  def create
    source.fetch("members", []).each do |member|
      manange_membership_for(member)
    end
  end

  # @param [Hash] member from the list of members in the yaml file
  def manange_membership_for(member)
    if list_has?(member)
      update_item(member)
    else
      create_item(member)
    end
  end

  # @param [Hash] member
  # returns [Boolean] if the list already has a member with the same uid
  def list_has?(member)
    list.members.map(&:uid).include?(uid(member))
  end

  private

    def pref_label(item = nil)
      item ||= source
      item.fetch("pref_label", nil)
    end

    def description(item = nil)
      item ||= source
      item.fetch("description", nil)
    end

    # A UID is required, so fetch will raise an error if it is missing
    def uid(item = nil)
      item ||= source
      item.fetch("uid")
    end

    # A list type is required. It can be either a string uri, or a string for a term in AICType
    def type
      build_uri(source.fetch("type"))
    end

    # An item type is required. It can be either a string uri, or a string for a term in AICType
    def item_type
      build_uri(source.fetch("item_type"))
    end

    def build_uri(type)
      return ::RDF::URI(type) if type =~ /^http/
      type.split(".").first.constantize.send(type.split(".").last)
    rescue StandardError
      raise NotImplementedError, "#{type} is not defined in one of Lakeshore's RDF::StrictVocabulary classes"
    end

    def list_types
      source.fetch("additional_types", []).map { |at| build_uri(at) } + [type]
    end

    def list_item_types
      source.fetch("additional_item_types", []).map { |at| build_uri(at) } + [item_type]
    end

    def list
      @list ||= if List.find_by_uid(uid)
                  update_list
                else
                  create_list
                end
    end

    # calling .create doesn't seem to work with .tap
    def create_list
      List.new(id: service.hash(uid)).tap do |list|
        list.pref_label = pref_label
        list.description = [description]
        list.uid = uid
        list_types.each { |t| list.type << t }
      end.save
      List.find_by_uid(uid)
    end

    def update_list
      list = List.find_by_uid(uid)
      list.update(pref_label: pref_label, description: [description])
      RDFTypeChangeService.call(list, list_types)
      list.reload
    end

    def create_item(member)
      list.members << ListItem.new(id: service.hash(uid(member))).tap do |item|
        list_item_types.each { |t| item.type << t }
        item.pref_label = pref_label(member)
        item.description = [description(member)]
        item.uid = uid(member)
      end
    end

    def update_item(member)
      item = ListItem.find_by_uid(uid(member))
      item.update(pref_label: pref_label(member), description: [description(member)])
      RDFTypeChangeService.call(item, list_item_types)
      item.reload
    end

    def service
      @service ||= UidMinter.new
    end
end
