# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'rack/test'
# require "rspec/rails"

RSpec.describe Application do
  include Rack::Test::Methods
  # let(:app) { Application.new }

  def app
    @app ||= Application
  end

  describe 'GET' do
    it 'should be successful' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'POST' do
    let(:valid_file) do
      Rack::Test::UploadedFile.new('spec/fixtures/example_valid_matrix.csv')
    end

    let(:invalid_matrix_file) do
      Rack::Test::UploadedFile.new('spec/fixtures/invalid_matrix.csv')
    end

    # Data input validation is the same for all endpoins, so we're safe choosing one them (/echo)
    context 'with valid matrix' do
      it 'returns status 200 OK' do
        post '/echo', file: valid_file
        expect(last_response.status).to eq 200
      end
    end

    context 'with no file' do
      it 'returns status 400 Bad Request' do
        post '/echo'
        expect(last_response.status).to eq 400
      end
    end

    context 'with invalid matrix' do
      it 'returns status 400 Bad Request' do
        post '/echo', file: invalid_matrix_file
        expect(last_response.status).to eq 400
      end
    end

    context '/echo' do
      it 'returns the input matrix' do
        expected_echo = <<-STRING.delete(' ').strip
          1,2,3
          4,5,6
          7,8,9
        STRING

        post '/echo', file: valid_file
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_echo)
      end
    end

    context '/invert' do
      it 'returns the inverted(traversed) matrix' do
        expected_invert = <<-STRING.delete(' ').strip
          1,4,7
          2,5,8
          3,6,9
        STRING

        post '/invert', file: valid_file
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_invert)
      end
    end

    context '/flatten' do
      it 'returns all elements of the matring as a single array' do
        expected_flatten = '1,2,3,4,5,6,7,8,9'

        post '/flatten', file: valid_file
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_flatten)
      end
    end

    context '/sum' do
      it 'sums all elements of the matrix' do
        expected_sum = 45
        post '/sum', file: valid_file
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_sum.to_s)
      end
    end

    context '/multiply' do
      it 'multiply all elements of the matrix' do
        expected_multiply = 362_880
        post '/multiply', file: valid_file
        expect(last_response.status).to eq 200
        expect(last_response.body).to eq(expected_multiply.to_s)
      end
    end
  end

  describe '/invert' do
  end
end
