source 'http://rubygems.org'

group :runtime do
  gem "alf", "~> 0.12.1"
  gem "gisele", "~> 0.5.1"
  gem "stamina-core", "~> 0.5.4"
  gem "sequel", "~> 3.33"
  gem "eventmachine", "= 1.0.0.beta.3"
end

platform 'mri' do
  group :extra do
    gem "sqlite3", "~> 1.3"
  end
end

platform 'jruby' do
  group :extra do
    gem "jdbc-sqlite3", "~> 3.7"
  end
end

group :development do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.11"
end
