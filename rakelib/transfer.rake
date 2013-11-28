desc 'transfer all tables'
task :transfer => [:environment] do
  config = Transfer::Config.new(File.expand_path('config/transfer.yml', APP_ROOT))
  worker = Transfer::Worker.new config
  worker.transfer_all
end

task :environment do
  require File.expand_path('../../lib/transfer', __FILE__)
end

