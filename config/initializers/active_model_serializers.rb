ActiveModelSerializers.config.adapter = :json
Oj.optimize_rails
Rails.application.routes.default_url_options[:host] = 'www.example.com'