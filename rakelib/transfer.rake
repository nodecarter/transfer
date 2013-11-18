desc 'transfer all tables'
task :transfer do
  #worker = Transfer::Worker.new
  #worker.unit_of_work do |db|
  #  worker.transfer_model(db, FeaturedVideo)
  #end
end

desc 'run tests'
task :test do
  ruby 'test/unit/transfer/config_test.rb'
end
