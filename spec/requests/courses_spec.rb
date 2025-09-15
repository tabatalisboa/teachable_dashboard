# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Courses', type: :request do
  let(:base) { ENV.fetch('TEACHABLE_API_BASE', 'https://developers.teachable.com') }

  before do
    ENV['TEACHABLE_API_KEY']   = 'test-key'
    ENV['TEACHABLE_PER_PAGE']  = '20'
  end

  describe 'GET / (index)' do
    it 'renders the list of published courses' do
      stub_request(:get, "#{base}/v1/courses")
        .with(query: hash_including(
          'published' => 'true',
          'page' => '1',
          'per_page' => '20'
        ))
        .to_return(
          status: 200,
          body: {
            courses: [
              { 'id' => 2_002_430, 'name' => 'Trees',      'heading' => 'Grow your knowledge' },
              { 'id' => 2_002_431, 'name' => 'Mushrooms',  'heading' => 'Foraging 101' }
            ],
            meta: { page: 1, number_of_pages: 1 }
          }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )

      get '/'
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Trees')
      expect(response.body).to include('Mushrooms')
    end
  end
end
