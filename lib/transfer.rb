module Transfer
end

#puts Dir.pwd
#lib_files = File.expand_path(File.join('..', '**', '*.rb'), __FILE__)
#puts "lib files: #{lib_files}"
#Dir.glob(lib_files).each do |lib_file|
#  file_to_require = File.expand_path(File.join('..', '..', lib_file), __FILE__)
#  puts "require #{file_to_require}"
#  require file_to_require
#end

$LOAD_PATH << File.expand_path('..', __FILE__)

require 'transfer/config'
