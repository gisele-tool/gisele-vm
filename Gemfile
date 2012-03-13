source 'http://rubygems.org'

group :runtime do
  gem "alf", "~> 0.12.1"
  gem "gisele", "~> 0.5.0"
  gem "stamina-core", "~> 0.5.4"
  gem "sequel", "~> 3.33"
end

platform 'mri' do
  group :extra do
    gem "sqlite3", "~> 1.3"
  end
  group :benchmarks do
    gem "ruby-prof", "~> 0.10.8"
  end
end

platform 'jruby' do
  group :extra do
    gem "jdbc-sqlite3", "~> 3.7"
  end
end

group :development do
  gem "rake", "~> 0.9.2"
  gem "rspec", "~> 2.8"
  gem "wlang", "~> 0.10.2"
end
