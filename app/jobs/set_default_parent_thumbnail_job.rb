# frozen_string_literal: true

class SetDefaultParentThumbnailJob < ApplicationJob
  queue_as :import

  def perform(parent_work:, importer_run_id: nil)
    parent_work.reload
    return if parent_work.thumbnail.present?

    curation_concerns = Hyrax.config.curation_concerns
    return unless curation_concerns.include?(parent_work.class)

    # the representative thumbnail for the parent should be the first page sorted alphanumerically by source_identifier
    sorted_children = parent_work.child_works.sort_by { |work| work.identifier.first }
    child_file_set = sorted_children&.first&.file_sets&.first
    if child_file_set.nil?
      reschedule(parent_work: parent_work, importer_run_id: importer_run_id)
      return false # stop current job from continuing to run after rescheduling
    end

    parent_work.representative = child_file_set
    parent_work.thumbnail = child_file_set
    parent_work.save
    # rubocop:disable Rails/SkipsModelValidations
    Bulkrax::ImporterRun.find(importer_run_id).increment!(:processed_parent_thumbnails) if importer_run_id.present?
  rescue ::StandardError => e
    Bulkrax::ImporterRun.find(importer_run_id).increment!(:failed_parent_thumbnails) if importer_run_id.present?
    # rubocop:enable Rails/SkipsModelValidations
    Bulkrax::Entry.find_by(identifier: parent_work.identifier.first).status_info(e) if parent_work
  end

  def reschedule(parent_work:, importer_run_id:)
    SetDefaultParentThumbnailJob.set(wait: 5.minutes)
                                .perform_later(parent_work: parent_work, importer_run_id: importer_run_id)
  end
end
