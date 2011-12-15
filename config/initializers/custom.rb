# Be sure to restart your server when you modify this file.

# custom initializer
#
# load default configuration

APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/rpubdb_config.yml")[Rails.env]
