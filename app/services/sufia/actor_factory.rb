# frozen_string_literal: true
module Sufia
  class ActorFactory < CurationConcerns::Actors::ActorFactory
    def self.stack_actors(curation_concern)
      [AddToCitiResourceActor,
       CreateWithRemoteFilesActor,
       CreateWithFilesActor,
       CurationConcerns::Actors::AddToCollectionActor,
       CurationConcerns::Actors::AddToWorkActor,
       CurationConcerns::Actors::AssignRepresentativeActor,
       CurationConcerns::Actors::AttachFilesActor,
       CurationConcerns::Actors::ApplyOrderActor,
       CurationConcerns::Actors::InterpretVisibilityActor,
       model_actor(curation_concern)]
    end
  end
end
