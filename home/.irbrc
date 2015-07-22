begin
  require 'pry'
  Pry.start
  exit
rescue LoadError
  puts "Pry not found, using 'irb' instead. Try gem install pry"
end