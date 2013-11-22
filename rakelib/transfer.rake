desc 'transfer all tables'
task :transfer do
  #worker = Transfer::Worker.new
  #worker.unit_of_work do |db|
  #  worker.transfer_model(db, FeaturedVideo)
  #end
end

task :environment do
  require File.expand_path('../../lib/transfer', __FILE__)
end

