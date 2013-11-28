desc 'transfer all tables'
task :transfer => [:environment] do
  config = Transfer::Config.new(File.expand_path('config/transfer.yml', APP_ROOT))
  worker = Transfer::Worker.new config
  table_name = ENV['TABLE_NAME']
  if table_name.blank?
    worker.transfer_all
  else
    worker.transfer_table(table_name.to_sym)
  end
end

task :environment do
  require File.expand_path('../../lib/transfer', __FILE__)
end

