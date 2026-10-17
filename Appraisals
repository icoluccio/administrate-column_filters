# ActiveSupport before 8.1 passes quirks_mode to JSON, which json 3.x removed, so those Rails versions pin json to 2.x.

appraise 'rails-7.1' do
  gem 'rails', '~> 7.1.0'
  gem 'json', '~> 2.7'
end

appraise 'rails-7.2' do
  gem 'rails', '~> 7.2.0'
  gem 'json', '~> 2.7'
end

appraise 'rails-8.0' do
  gem 'rails', '~> 8.0.0'
  gem 'json', '~> 2.7'
end

appraise 'rails-8.1' do
  gem 'rails', '~> 8.1.0'
end
