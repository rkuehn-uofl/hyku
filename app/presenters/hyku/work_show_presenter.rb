# frozen_string_literal: true

module Hyku
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    Hyrax::MemberPresenterFactory.file_presenter_class = Hyrax::FileSetPresenter

    delegate :alternative_title,
             :building_date,
             :city,
             :code,
             :collection_information,
             :contributor_role,
             :county,
             :creator_role,
             :cultural_context,
             :date_digital,
             :decade,
             :digitization_specification,
             :extent,
             :format,
             :invoice_information,
             :iqb,
             :issue,
             :language_script,
             :location,
             :material,
             :media_type,
             :mesh,
             :neighborhood,
             :operating_area,
             :ordering_information,
             :ornamentation,
             :people_represented,
             :photo_comment,
             :place_original,
             :production,
             :region,
             :related_image,
             :resource_query,
             :series,
             :story,
             :street,
             :style,
             :tab_heading,
             :table_of_contents,
             :technique,
             :transcription_translation,
             :volume,
             to: :solr_document

    # are there any pages to display in uv?
    def derived_files?
      derived_members.present?
    end

    def derived_members
      @derived_members ||= member_presenters_for(list_of_item_ids_to_display).select do |member|
        member.solr_document['is_derived_ssi'] == 'true'
      end
    end

    # assumes there can only be one doi
    def doi
      doi_regex = %r{10\.\d{4,9}\/[-._;()\/:A-Z0-9]+}i
      doi = extract_from_identifier(doi_regex)
      doi&.join
    end

    # unlike doi, there can be multiple isbns
    def isbns
      isbn_regex = /((?:ISBN[- ]*13|ISBN[- ]*10|)\s*97[89][ -]*\d{1,5}[ -]*\d{1,7}[ -]*\d{1,6}[ -]*\d)|
                    ((?:[0-9][-]*){9}[ -]*[xX])|(^(?:[0-9][-]*){10}$)/x
      isbns = extract_from_identifier(isbn_regex)
      isbns&.flatten&.compact
    end

    private

      def extract_from_identifier(rgx)
        if solr_document['identifier_tesim'].present?
          ref = solr_document['identifier_tesim'].map do |str|
            str.scan(rgx)
          end
        end
        ref
      end
  end
end
