# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Art`
require 'rails_helper'

RSpec.describe Art do
  describe 'indexer' do
    subject { described_class.indexer }

    it { is_expected.to eq ArtIndexer }
  end

  describe 'with custom slugs' do
    let(:this_object) { create(:art) }

    include_examples("object includes slugs")
  end
end
