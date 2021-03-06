# frozen_string_literal: true

require 'middleware'
require 'yaml'

describe Middleware do
  let(:middleware) { Middleware.instance }

  context 'initializer' do
    it 'must load endpoints configs' do
      # Load YML.
      apis_yml_file = File.read('config/apis.yml')
      apis_yml = YAML.safe_load(apis_yml_file)

      # Load YML as a Hash.
      yml_seriealized = apis_yml.inspect
      apis = JSON.parse yml_seriealized.gsub('=>', ':')

      # Expected values.
      expected_loaded_apis = apis['apis'].size

      # Expectations.
      middleware_apis = middleware.apis
      expect(middleware_apis.size).to eq expected_loaded_apis
    end

    it 'must load access tokens' do
      # Load YML.
      access_tokens_yml_file = File.read('config/access_tokens.yml')
      access_tokens_yml = YAML.safe_load(access_tokens_yml_file)
      # Load YML as a Hash.
      yml_seriealized = access_tokens_yml.inspect
      access_tokens = JSON.parse yml_seriealized.gsub('=>', ':')

      # Expected values.
      expected_loaded_access_tokens = access_tokens['access_tokens'].size

      # Expectations.
      middleware_access_tokens = middleware.access_tokens
      expect(middleware_access_tokens.size).to eq expected_loaded_access_tokens
    end

    it 'is a singleton' do
      expect(Middleware.respond_to?(:new)).to be false
    end
  end

  context '.do_request' do
    before(:each) do
      # Simulate the API response for find a card by id.
      find_card_by_id_response = '{"data":{"card":{"pipe":{"id":"1182718"},
      "title":"Oséias "}}}'

      # Stub find card by id to avoid HTTP requests.
      stub_request(:post, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_card_by_id_response, headers: {})

      stub_request(:get, /api.pipefy.com/)
        .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
        .to_return(status: 200, body: find_card_by_id_response, headers: {})
    end

    it 'does a GET request' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'GET'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq '200'
    end

    it 'does a POST request' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'POST'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq '200'
    end

    it 'does a request to an API with status 200' do
      api = 'pipefy'
      query = 'whatever'

      http_method = 'POST'
      response = middleware.do_request(api, query, http_method)

      expect(response.code).to eq '200'
    end
  end
end
