# frozen_string_literal: true
class RDFTypeChangeService
  # @param [ActiveFedora::Base] resource
  # @param [Array<RDF::URI>] types
  def self.call(resource, types)
    new(resource, types).delete.insert
  end

  attr_reader :resource, :types

  def initialize(resource, types)
    @resource = resource
    @types = types
  end

  def delete
    delete_query = "PREFIX aictype: <http://definitions.artic.edu/ontology/1.0/type/> " \
                   "DELETE { <> a #{types_to_delete.join(', ')} } WHERE { }"
    sparql_update(delete_query)
  end

  def insert
    update_query = "PREFIX aictype: <http://definitions.artic.edu/ontology/1.0/type/> " \
                   "INSERT { <> a #{types_to_add.join(', ')} } WHERE { }"
    sparql_update(update_query)
  end

  private

    def types_to_delete
      resource.type.reject { |x| required_types.include?(x) }.map { |t| "aictype:#{t.path.split('/').last}" }
    end

    def types_to_add
      types.map { |t| "aictype:#{t.path.split('/').last}" }
    end

    def required_types
      resource.class.new.type + inherent_types
    end

    # Types that are inherent to the model, such as anything Fedora, PCDM, or WC3
    def inherent_types
      resource.type.map do |type|
        type if type.host =~ /pcdm|fedora|w3/
      end
    end

    def sparql_update(query)
      result = ActiveFedora.fedora.connection.patch(resource.uri, query, "Content-Type" => "application/sparql-update")
      return self if result.status == 204
      raise "Problem updating #{result.status} #{result.body}"
    end
end
