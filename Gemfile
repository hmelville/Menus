source 'https://rubygems.org'


 #####
#     #   ####   #####   ######
#        #    #  #    #  #
#        #    #  #    #  #####
#        #    #  #####   #
#     #  #    #  #   #   #
 #####    ####   #    #  ######

# !!IMPORTANT!! Since we are currently limited to using activerecord-sqlserver-adapter 4.1 (see below)
# we are also limited to Rails 4.1.x
gem 'rails', '~> 4.1.5'
gem 'activeresource', require: 'active_resource'      # Required for Rails 4 compatibility
gem 'bcrypt', '~> 3.1.7'                              # Use ActiveModel has_secure_password
gem 'activerecord-session_store'                      # We store sessions in the DB

# Data Stuff
# Since we are restricted to Rails 4.1.x we are also limited to mysql2 0.3.x
gem 'mysql2', '~> 0.3.0'
gem 'tiny_tds', group: [:sql_server]
gem 'rbnacl-libsodium'
gem 'rbnacl', '~> 3.0'

# Framework/Helpers
gem 'awesome_nested_set'                              # For model nesting (used in menus)
gem 'aws-sdk', '~> 1.66'                              # for file storage (paperclip 4.x requires aws-sdk < 2.0)
gem 'cancancan'                                       # For role based permissions (the continuation of the no longer active cancan gem)
gem 'draper'                                          # Adds presentation wrapper to models (mediates between M & V in MVC)
gem 'jbuilder', '~> 2.0'                              # JSON DSL. Read more: https://github.com/rails/jbuilder
gem 'paper_trail'                                     # keeps an audit trail of model changes
gem 'ransack'                                         # For data filtering
gem 'paranoia', '~> 2.0'                              # Marks models as deleted instead of actually deleting them
gem 'delayed_job_active_record'                       # Asynchronous task execution
gem 'daemons'                                         # Needed to run delayed job workers
gem 'exception_notification', '~> 4.0.1'              # Send emails when bad things happen. >=4.1 incompatible with Rails 4.1
gem 'working_hours'                                   # Adds methods for doing time calculations that ignore non-working
                                                      # hours (unlike the business_time gem this one handles minutes, not just hours
gem 'business_time'
gem "savon"
gem "default_value_for"

gem "useragent"
gem "netaddr"
gem "net-sftp"
gem "htmlentities"                                    # Used to decode HTML for the plain text mailshots


#######
#           #    #       ######   ####
#           #    #       #       #
#####       #    #       #####    ####
#           #    #       #            #
#           #    #       #       #    #
#           #    ######  ######   ####

gem 'paperclip', '~> 4.3'                             # for file handling, pin to v4 as v5 needs Rails 4.2
gem 'axlsx_rails'                                     # Render to Excel files
gem 'simple_xlsx_reader'                              # Read spreadhseets ("spreadhseet" gem doesn't support xlsx;


#     #   ###
#     #    #
#     #    #
#     #    #
#     #    #
#     #    #
 #####    ###

# HAML to render HTML views
gem 'haml'
gem 'haml-rails'

# Use SCSS for stylesheets, with Foundation CSS
# framework and Awseome Icons
gem 'foundation-rails', '~> 5.5'
gem 'font-awesome-sass', '~> 4.5'
gem 'sass-rails'

gem 'kaminari'                                        # for pagination
gem 'simple_form'
gem "cocoon"
gem 'google_visualr'
gem 'recaptcha', require: 'recaptcha/rails'

      #                          #####
      #    ##    #    #    ##   #     #   ####   #####      #    #####    #####
      #   #  #   #    #   #  #  #        #    #  #    #     #    #    #     #
      #  #    #  #    #  #    #  #####   #       #    #     #    #    #     #
#     #  ######  #    #  ######       #  #       #####      #    #####      #
#     #  #    #   #  #   #    # #     #  #    #  #   #      #    #          #
 #####   #    #    ##    #    #  #####    ####   #    #     #    #          #

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'el_finder'
gem 'rails4-autocomplete'
gem 'tinymce-rails'

######
#     #  ######  #    #
#     #  #       #    #
#     #  #####   #    #
#     #  #       #    #
#     #  #        #  #
######   ######    ##

gem 'hirb'
gem 'active_record_query_trace', '~> 1.5.4', group: [:development, :test]

# Documentation
gem 'yard', group: [:development, :test]
gem 'yard-activerecord', group: [:development, :test]
gem 'yard-rails', group: [:development, :test]

# Use debugger
gem 'byebug', group: [:development, :test]

######
#     #  #    #  #    #   #####     #    #    #  ######
#     #  #    #  ##   #     #       #    ##  ##  #
######   #    #  # #  #     #       #    # ## #  #####
#   #    #    #  #  # #     #       #    #    #  #
#    #   #    #  #   ##     #       #    #    #  #
#     #   ####   #    #     #       #    #    #  ######


gem 'unicorn'# Use unicorn as the app server
gem 'rack-ssl', :require => 'rack/ssl' # to force requests to use ssl
gem 'dalli' # A Memcache client

gem "spreadsheet", :require => false

group :development, :test do
  # gem 'rspec-rails', '~> 3.0'
  gem 'guard', '2.11.1'
  # gem 'guard-rspec', require: false
  gem 'terminal-notifier-guard'
  # gem 'capybara', '~> 2.4.4'
  gem 'factory_girl', '~> 4.5.0'
  gem 'factory_girl_rails'
  # gem 'selenium-webdriver', '~> 2.47.1'
  gem 'faker'
  gem 'rubocop', require: false
  gem 'bullet'
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem 'minitest', "~> 5.8.4"
  gem "mocha", "~> 1.1.0"
end
