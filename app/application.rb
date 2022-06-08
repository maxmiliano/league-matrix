# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'development'

require 'bundler'
require 'matrix'
require 'tempfile'

Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'sinatra/base'
require 'csv'

# Sinatra Application to listen certain endpoints
class Application < Sinatra::Base
  set :show_exceptions, :after_handler

  # Let's just add some information if user ends up on the root application
  get '/' do
    "You should use curl command line to post a csv file like this:\n'curl -X POST -F 'file=@matrix.csv' 'http://localhost:4567/flatten'"
  end

  before do
    if request.request_method == 'POST'

      valid_params = _validate_params(params)
      if valid_params
        @matrix = _read_matrix
        valid_params &&= _validate_matrix_size(@matrix)
      end

      error 400, (@error_message || 'Bad request') unless valid_params

    end
  end

  post '/echo' do
    _stringify(@matrix)
  end

  post '/invert' do
    inverted = @matrix.transpose
    _stringify(inverted)
  end

  post '/flatten' do
    @matrix.flatten.join(',')
  end

  post '/sum' do
    @matrix.flatten.map(&:to_i).sum.to_s
  end

  post '/multiply' do
    @matrix.flatten.map(&:to_i).inject(:*).to_s
  end

  def _validate_params(params)
    unless params.key?(:file)
      @error_message = 'File not found.'
      return false
    end

    @file = params[:file][:tempfile] if params[:file].is_a?(Hash) # || params[:file]

    unless @file
      @error_message = 'Invalid file. Could load your CSV file.'
      return false
    end

    true
  end

  def _read_matrix
    file_data = @file
    csv_data = CSV.read(file_data)
    csv_data.each.to_a
  end

  def _stringify(matrix)
    matrix.map { |row| row.join(',') }.join("\n")
  end

  # Matrix must be square to be valid (same count of cols and rows)
  # Let's not repeat ourselves, as Ruby has a Matrix::square? method to deal with that
  def _validate_matrix_size(matrix)
    mat = Matrix[*matrix]
    unless mat&.square?
      @error_message = 'Invalid Matrix. Lines and cols must be of the same size.'
      return false
    end

    true
  end

  error do
    status 400, @error_message || 'Bad request'
  end
end
