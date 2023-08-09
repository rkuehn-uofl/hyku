# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Art`
module Hyrax
  # Generated form for Art
  class ArtForm < Hyrax::Forms::WorkForm
    include Hyrax::ArtFormTerms
    self.model_class = ::Art

    self.required_fields -= %i[
      creator
      keyword
      rights_statement
      title
    ]

    self.terms -= [
      :based_near
    ]

    self.required_fields += %i[
      identifier
      title
    ]

    self.terms += [
      :alternative_title,
      :creator_role,
      :contributor_role,
      :resource_type,
      :collection_information,
      :digitization_specification,
      :date_digital,
      :media_type,
      :format,
      :ordering_information,
      :resource_query
    ]

    self.terms += %i[
      people_represented
      cultural_context
      extent
      language_script
      material
      ornamentation
      place_original
      related_image
      style
      technique
      transcription_translation
    ]
  end
end
