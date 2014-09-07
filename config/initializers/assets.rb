# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.log_level = :error

# Rails.application.config.assets.precompile += %w( appointment.js )
Rails.application.config.assets.precompile += %w( fullcalendar.js )
Rails.application.config.assets.precompile += %w( jquery_ui_min.js )
Rails.application.config.assets.precompile += %w( moment.min.js )

Rails.application.config.assets.precompile += %w( appointment.js )


Rails.application.config.assets.precompile += %w( fullcalendar.css )
Rails.application.config.assets.precompile += %w( jquery_ui.css )
Rails.application.config.assets.precompile += %w( style.css )
Rails.application.config.assets.precompile += %w( events.js )
Rails.application.config.assets.precompile += %w( availability.js )
