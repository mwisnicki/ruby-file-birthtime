Dir.chdir File.dirname(__FILE__)
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../ext"
Dir["**/test_*.rb"].each { |file| load file }

