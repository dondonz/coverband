# frozen_string_literal: true

require File.expand_path('../test_helper', File.dirname(__FILE__))
require 'aws-sdk'
require File.expand_path('../../lib/coverband/reporters/web', File.dirname(__FILE__))
require 'rack/test'

ENV['RACK_ENV'] = 'test'

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.2.0')
  module Coverband
    class S3WebTest < Test::Unit::TestCase
      include Rack::Test::Methods

      def app
        Coverband::Reporters::Web.new
      end

      def teardown
        Coverband.configuration.s3_bucket = nil
      end

      # TODO add tests for all endpoints
      test 'renders index content' do
        get '/'
        assert last_response.ok?
        assert_match 'Coverband Web Admin Index', last_response.body
      end

      test 'renders show content' do
        Coverband.configuration.s3_bucket = 'coverage-bucket'
        Coverband::Utils::S3Report.any_instance.expects(:retrieve).returns('content')
        get '/show'
        assert last_response.ok?
        assert_equal 'content', last_response.body
      end
    end
  end
end
