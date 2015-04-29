class AICMix < RDF::StrictVocabulary("http://definitions.artic.edu/ontology/1.0/mixin/")
  
  term :Citi,
    comment: "Resource imported from and maintained by CITI".freeze,
    label: "CITI Resource".freeze
  term :CitiPrivate,
    subClassOf: "AICMix:Citi".freeze,
    comment: "CITI resource to which only CITI has access".freeze,
    label: "CITI Private Resource".freeze
  term :Derivative,
    comment: "Instance that is automatically derived from another instance".freeze

end
