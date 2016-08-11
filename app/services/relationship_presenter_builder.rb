# frozen_string_literal: true
class RelationshipPresenterBuilder
  attr_reader :citi_uid, :model, :ability, :request

  # @param citi_uid [String] from the parameters hash
  # @param model [String] from the parameters hash
  # @param ability [Ability] available from the calling controller
  # @param request [ActionDispatch::Request] available from the calling controller
  def initialize(citi_uid, model, ability, request)
    @citi_uid = citi_uid
    @model = model.capitalize
    @ability = ability
    @request = request
  end

  def call
    return unless resource
    presenter.new(SolrDocument.new(resource), ability, request)
  end

  private

    def presenter
      "#{resource.model}Presenter".constantize
    end

    def resource
      return unless citi_uid && model
      @resource ||= ActiveFedora::SolrService.query("citi_uid_ssim:\"#{citi_uid}\"",
                                                    fq: "has_model_ssim:#{model}").first
    end
end
