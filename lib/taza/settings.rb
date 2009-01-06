require 'activesupport'

module Taza
  class Settings
    # The config settings from the site.yml and config.yml files.  
    # ENV variables will override the settings.
    #
    # Example:
    #   Taza::Settings.config('google')
    def self.config(site_name)
      env_settings = {}
      keys = %w(browser driver timeout server_ip server_port)
      keys.each do |key|
        env_settings[key.to_sym] = ENV[key.upcase] if ENV[key.upcase]
      end
      
      default_settings = {:browser => :firefox, :driver => :selenium}
      
      # Because of the way #merge works, the settings at the bottom of the list,
      # trump those at the top.
      settings = site_file(site_name).merge(
                   default_settings.merge(
                     config_file.merge(
                       env_settings)))

      settings[:browser] = settings[:browser].to_sym
      settings[:driver] = settings[:driver].to_sym

      settings
    end

    # Returns a hash corresponding to the project config file.
    def self.config_file
      return {} unless File.exists?(config_file_path)
      YAML.load_file(config_file_path)
    end

    def self.config_file_path # :nodoc:
      File.join(path, 'config', 'config.yml')
    end
    
    # Returns a hash for the currently specified test environment
    def self.site_file(site_name) # :nodoc:
      YAML.load_file(File.join(path, 'config', "#{site_name.underscore}.yml"))[ENV['TAZA_ENV']]
    end

    def self.path # :nodoc:
      '.'
    end
  end
end
