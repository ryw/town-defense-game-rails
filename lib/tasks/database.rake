namespace :db do
  namespace :fixtures do
    desc "Load fixtures from /db/  Load specific fixtures using FIXTURES=x,y"
    task :import => :environment do
      require 'active_record/fixtures'
      fixtures_env = ENV["FIXTURES_ENV"] || RAILS_ENV 
      ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)
      (ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : Dir.glob(File.join(RAILS_ROOT, 'db', 'fixtures', fixtures_env, '*.{yml,csv}'))).each do |fixture_file|
        Fixtures.create_fixtures("db/fixtures/#{fixtures_env}", File.basename(fixture_file, '.*'))
      end
    end
  end
end