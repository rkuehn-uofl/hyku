# frozen_string_literal: true
if ENV.fetch('HYKU_BULKRAX_ENABLED', false)
  Bulkrax.setup do |config|
    config.parsers = [
      { name: 'CSV - Comma Separated Values',
        class_name: 'Bulkrax::CsvParser',
        partial: 'csv_fields'
      }
    ]
    # WorkType to use as the default if none is specified in the import
    # Default is the first returned by Hyrax.config.curation_concerns
    config.default_work_type = 'Image'

    # Path to store pending imports
    config.import_path = 'tmp/imports'

    # Path to store exports before download
    config.export_path = 'tmp/exports'
    # Server name for oai request header
    # config.server_name = 'my_server@name.com'

    config.field_mappings['Bulkrax::CsvParser'] = {
      'alternative_title' => { from: ['alternative_title'], split: ';' },
      'building_date' => { from: ['building_date'], split: ';' },
      'city' => { from: ['city'], split: ';' },
      'code' => { from: ['code'], split: ';' },
      'collection_information' => { from: ['collection_information'], split: ';' },
      'contributor' => { from: ['contributor'], split: ';' },
      'contributor_role' => { from: ['contributor_role'], split: ';' },
      'county' => { from: ['county'], split: ';' },
      'creator' => { from: ['creator'], split: ';' },
      'creator_role' => { from: ['creator_role'], split: ';' },
      'cultural_context' => { from: ['cultural_context'], split: ';' },
      'date_created' => { from: ['date_original'] },
      'date_digital' => { from: ['date_digital'] },
      'decade' => { from: ['decade'], split: ';' },
      'description' => { from: ['description'] },
      'digitization_specification' => { from: ['digitization_specification'] },
      'extent' => { from: ['duration'] },
      'format' => { from: ['format'] },
      'identifier' => { from: ['source_identifier'], source_identifier: true },
      'invoice_information' => { from: ['invoice_information'] },
      'issue' => { from: ['issue'] },
      'keyword' => { from: ['keyword'], split: ';' },
      'language' => { from: ['language'], split: ';' },
      'language_script' => { from: ['language_script'], split: ';' },
      'license' => { from: ['license'], split: ';' },
      'location' => { from: ['location'], split: ';' },
      'material' => { from: ['material'], split: ';' },
      'media_type' => { from: ['media_type'], split: ';' },
      'mesh' => { from: ['mesh'], split: ';' },
      'neighborhood' => { from: ['neighborhood'], split: ';' },
      'operating_area' => { from: ['operating_area'], split: ';' },
      'ordering_information' => { from: ['ordering_information'] },
      'ornamentation' => { from: ['ornamentation'] },
      'people_represented' => { from: ['people_represented'], split: ';' },
      'photo_comment' => { from: ['photo_comment'] },
      'place_original' => { from: ['place_original'], split: ';' },
      'production' => { from: ['production'] },
      'publisher' => { from: ['repository'], split: ';' },
      'region' => { from: ['region'], split: ';' },
      'related_image' => { from: ['related_image'], split: ';' },
      'related_url' => { from: ['related_resource'], split: ';' },
      'resource_query' => { from: ['resource_query'], split: ';' },
      'resource_type' => { from: ['object_type'], split: ';' },
      'rights_statement' => { from: ['rights_statement'], split: ';' },
      'searchable_text' => { from: ['searchable_text'] },
      'series' => { from: ['series'] },
      'source' => { from: ['source'], split: ';' },
      'story' => { from: ['story'] },
      'street' => { from: ['street'], split: ';' },
      'style' => { from: ['style'], split: ';' },
      'subject' => { from: ['subject'], split: ';' },
      'tab_heading' => { from: ['tab_heading'] },
      'table_of_contents' => { from: ['table_of_contents'] },
      'technique' => { from: ['technique'], split: ';' },
      'title' => { from: ['title'] },
      'transcription_translation' => { from: ['transcription_translation'] },
      'volume' => { from: ['volume'] }
    }

    # support v.2.0 parent/child relationships: https://github.com/samvera-labs/bulkrax/wiki/Configuring-Bulkrax#parent-child-relationship-field-mappings
    config.field_mappings['Bulkrax::CsvParser'].merge!({
      'parents' => { from: ['parents'], split: /\s*[;|]\s*/, related_parents_field_mapping: true },
      'children' => { from: ['children'], split: /\s*[;|]\s*/, related_children_field_mapping: true },
    })

    # By default no parent-child relationships are added
    # Field_mapping for establishing a collection relationship (FROM work TO collection)
    # This value IS NOT used for OAI, so setting the OAI parser here will have no effect
    # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
    # The default value for CSV is collection
    # Add/replace parsers, for example:
    # config.collection_field_mapping['Bulkrax::RdfEntry'] = 'http://opaquenamespace.org/ns/set'

    # Field mappings
    # Create a completely new set of mappings by replacing the whole set as follows
    #   config.field_mappings = {
    #     'Bulkrax::OaiDcParser' => { **individual field mappings go here*** }
    #   }

    # Add to, or change existing mappings as follows
    #   e.g. to exclude date
    #   config.field_mappings['Bulkrax::OaiDcParser']['date'] = { from: ['date'], excluded: true  }

    # To duplicate a set of mappings from one parser to another
    #   config.field_mappings['Bulkrax::OaiOmekaParser'] = {}
    #   config.field_mappings['Bulkrax::OaiDcParser'].each {|key,value| config.field_mappings['Bulkrax::OaiOmekaParser'][key] = value }

    # Properties that should not be used in imports/exports. They are reserved for use by Hyrax.
    # config.reserved_properties += ['my_field']
  end
end
