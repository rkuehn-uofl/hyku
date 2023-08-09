# frozen_string_literal: true

module Hyrax
  module ArtFormTerms
    include Hyrax::Forms
    # overrides Hyrax::Forms::WorkForm
    # to display 'license' in the 'base-terms' div on the user dashboard "Add New Work" description
    # by getting iterated over in hyrax/app/views/hyrax/base/_form_metadata.html.erb
    def primary_terms
      super + %i[
        alternative_title
        creator
        creator_role
        contributor
        contributor_role
        description
        transcription_translation
        subject
        style
        technique
        material
        ornamentation
        cultural_context
        keyword
        language
        language_script
        people_represented
        place_original
        date_created
        resource_type
        source
        related_image
        collection_information
        publisher
        rights_statement
        ordering_information
        license
        related_url
        resource_query
      ]
    end
  end
end
