class Tag < ActiveFedora::Base
  
  type ::AICType.Tag
  has_many :generic_files, inverse_of: :tags, class_name: "GenericFile"
  
  property :content, predicate: ::AIC.content do |index|
    index.as :stored_searchable
  end 
  
  property :category, predicate: ::AIC.category do |index|
    index.as :stored_searchable
  end

end
