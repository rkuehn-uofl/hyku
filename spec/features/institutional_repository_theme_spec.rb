# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin can select institutional repository theme', type: :feature, js: true, clean: true do
  let(:account) { FactoryBot.create(:account) }
  let(:admin) { FactoryBot.create(:admin, email: 'admin@example.com', display_name: 'Adam Admin') }
  let(:user) { create :user }
  let!(:work) do
    create(:generic_work,
           title: ['Llamas and Alpacas'],
           keyword: ['llama', 'alpaca'],
           resource_type: ['Software or Program Code'],
           user: user)
  end

  context 'as a repository admin' do
    it 'sets the institutional repository theme when the theme form is saved' do
      login_as admin
      visit 'admin/appearance'
      click_link('Themes')
      select('Institutional Repository', from: 'Home Page Theme')
      find('body').click
      click_on('Save')
      site = Site.last
      account.sites << site
      allow_any_instance_of(ApplicationController).to receive(:current_account).and_return(account)
      expect(site.home_theme).to eq('institutional_repository')
      visit '/'
      expect(page).to have_css('body.institutional_repository')
    end
  end

  context 'when the institutional repository theme is selected' do
    it 'renders the partials in the theme folder' do # rubocop:disable RSpec/ExampleLength
      skip 'not used by Louisville theme'

      login_as admin
      visit '/admin/appearance'
      click_link('Themes')
      select('Institutional Repository', from: 'Home Page Theme')
      find('body').click
      click_on('Save')
      site = Site.last
      account.sites << site
      allow_any_instance_of(ApplicationController).to receive(:current_account).and_return(account)
      visit '/'
      expect(page).to have_css('body.institutional_repository')
      expect(page).to have_css('nav.navbar.navbar-inverse.navbar-static-top.institutional-repsitory-nav')
      expect(page).to have_css('div.ir-stats')
      expect(page).to have_css('div.institutional-repository-featured-researcher')
      expect(page).to have_css('div.institutional-repository-recent-uploads')
      expect(page).to have_css('div.col-xs-12.col-md-8.institutional-repository.collections-container')
      expect(page).not_to have_css('ul#homeTabs')
      expect(page).not_to have_css('ul.nav.nav-pills')
      expect(page).not_to have_css('nav.navbar.navbar-inverse.navbar-static-top.cultural-repository-nav')
      expect(page).not_to have_css('background-container-gradient')
    end

    it 'renders the stats carousel if there are more than 6 resource_types' do
      skip 'not used by Louisville theme'
      work.resource_type = [
        'Article', 'Audio', 'Book', 'Capstone Project', 'Conference Proceeding', 'Dataset', 'Software or Program Code'
      ]
      work.save
      login_as admin
      visit '/admin/appearance'
      click_link('Themes')
      select('Institutional Repository', from: 'Home Page Theme')
      find('body').click
      click_on('Save')
      site = Site.last
      account.sites << site
      allow_any_instance_of(ApplicationController).to receive(:current_account).and_return(account)
      visit '/'
      expect(page).to have_css('div.institutional-repository-carousel')
    end
  end
end
