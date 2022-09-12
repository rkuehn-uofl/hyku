# frozen_string_literal: true

# OVERRIDE Hyrax 2.9.6 to make customizations to the manifest that will allow metadata to be seen in the UV side panel
module Hyrax
  module ManifestBuilderServiceDecorator
    private

      # OVERRIDE Hyrax 2.9.6 to make customizations to the manifest that will allow metadata to be seen in the UV side panel
      def sanitized_manifest(presenter:)
        # ::IIIFManifest::ManifestBuilder#to_h returns a
        # IIIFManifest::ManifestBuilder::IIIFManifest, not a Hash.
        # to get a Hash, we have to call its #to_json, then parse.
        #
        # wild times. maybe there's a better way to do this with the
        # ManifestFactory interface?

        manifest = manifest_factory.new(presenter).to_h
        docs = get_solr_docs(presenter)

        hash = JSON.parse(manifest.to_json)
        hash['label'] = sanitize_value(hash['label']) if hash.key?('label')
        hash.delete('description') # removes default description since it's in the metadata fields
        hash['sequences']&.each do |sequence|
          sequence['canvases']&.each do |canvas|
            canvas['label'] = sanitize_value(canvas['label'])
            # uses the '@id' property which is a URL that contains the FileSet id
            file_set_id = canvas['@id'].split('/').last
            # finds the image that the FileSet is attached to and creates metadata on that canvas
            image = docs.select do |doc|
              doc[:member_ids_ssim]&.include?(file_set_id) && doc[:has_model_ssim] != ["FileSet"]
            end.first

            canvas_metadata = get_canvas_metadata(metadata_fields, image)
            canvas['metadata'] = canvas_metadata.compact
          end
        end

        sort_hash_by_identifier(hash)
        hash
      end

      def sort_hash_by_identifier(hash)
        hash["sequences"].first["canvases"].sort_by! do |canvas|
          canvas["metadata"].select { |h| h[:label] == "Identifier" }.first[:value]
        end
      end

      def get_solr_docs(presenter)
        parent_id_and_child_ids = ([presenter._source['id']] + presenter._source['member_ids_ssim'])
        query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(parent_id_and_child_ids)
        solr_hits = ActiveFedora::SolrService.query(query, rows: 100_000)
        solr_hits.map { |solr_hit| ::SolrDocument.new(solr_hit) }
      end

      def cast_to_value(image:, field_name:, options:)
        if options[:render_as] == :faceted
          Array(image.send(field_name)).map do |value|
            # to make sure we have the fields faceted as _sim, we do this:
            # https://github.com/samvera/hyrax/blob/426575a9065a5dd3b30f458f5589a0a705ad7be2/app/renderers/hyrax/renderers/faceted_attribute_renderer.rb#L14-L16
            search_field = Solrizer.solr_name(field_name, :facetable, type: :string)
            path = Rails.application.routes.url_helpers.search_catalog_path(
              :"f[#{search_field}][]" => value, locale: I18n.locale
            )
            path += '&include_child_works=true' if image["is_child_bsi"] == true
            "<a href='#{path}' target='_blank'>#{value}</a>"
          end
        else
          make_link(image.send(field_name))
        end
      end

      def make_collection_link(collection_ids, collection_titles)
        collection_ids_and_titles_map = {}
        collection_ids.each_with_index.map { |id, i| collection_ids_and_titles_map[id] = collection_titles[i] }
        collection_ids_and_titles_map.map do |id, title|
          "<a href='/collections/#{id}' target='_blank'>#{title}</a>"
        end
      end

      MAKE_LINK_REGEX = %r{
        \b
        (
          (?: [a-z][\w-]+:
            (?: /{1,3} | [a-z0-9%] ) |
              www\d{0,3}[.] |
              [a-z0-9.\-]+[.][a-z]{2,4}/
          )
          (?:
            [^\s()<>]+ | \(([^\s()<>]+|(\([^\s()<>]+\)))*\)
          )+
          (?:
            \(([^\s()<>]+|(\([^\s()<>]+\)))*\) |
            [^\s`!()\[\]{};:'".,<>?«»〝〞‘‛]
          )
        )
      }ix

      # @note This method turns link looking strings into links
      def make_link(text)
        Array(text).map do |t|
          t.gsub(MAKE_LINK_REGEX) do |url|
            "<a href='#{url}' target='_blank'>#{url}</a>"
          end
        end
      end

      def metadata_fields
        # reference views/hyrax/base/_metadata.html.erb
        {
          title: {},
          description: {}
        }.merge(HYKU_METADATA_RENDERING_ATTRIBUTES)
          .merge(searchable_text: {})
      end

      def get_canvas_metadata(metadata_fields, image)
        metadata_fields.map do |field_name, options|
          label = Hyrax::Renderers::AttributeRenderer.new(field_name, nil).label
          if field_name == :collection
            next unless image[:member_of_collection_ids_ssim]&.present?
            {
              label: label,
              value: make_collection_link(image[:member_of_collection_ids_ssim], image[:member_of_collections_ssim])
            }
          else
            next if image.try(field_name)&.first.blank?
            { label: label, value: cast_to_value(image: image, field_name: field_name, options: options) }
          end
        end
      end
  end
end

Hyrax::ManifestBuilderService.prepend(Hyrax::ManifestBuilderServiceDecorator)
