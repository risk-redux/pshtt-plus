require_relative "boot"

require "rails/all"

require 'csv'
require 'digest'
require 'resolv'
require 'net/http'
require 'openssl'
require './app/datatables/domain_table'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PshttPlus
  class Application < Rails::Application
    config.app_name = "pshtt-plus"
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    config.active_job.queue_adapter = :sidekiq

    # To support CORS for Observable requests.
    config.action_dispatch.default_headers = {
      'Access-Control-Allow-Origin' => 'https://egyptiankarim.static.observableusercontent.com',
      'Access-Control-Request-Method' => "GET"
    }
  end
end
