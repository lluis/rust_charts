require 'redmine'

Rails.logger.info 'Starting rust plugin'

ActiveRecord::Base.default_timezone = :local

Redmine::Plugin.register :rust_charts do
  name 'rust_charts'
  author 'tictacbum'
  description 'charts for rust GamingOnLinux server'
  version '0.1'

end
