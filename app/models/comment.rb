class Comment < ActiveFedora::Base
  
  type ::AICType.Comment
  has_many :generic_files, inverse_of: :comments, class_name: "GenericFile"
  
  property :content, predicate: ::AIC.content do |index|
    index.as :stored_searchable
  end 
  
  property :category, predicate: ::AIC.category do |index|
    index.as :stored_searchable
  end

end
