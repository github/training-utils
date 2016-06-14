#!/usr/bin/env ruby
require 'CSV'

file = File.open(ARGV[0], "r:ISO-8859-1:ISO-8859-1")
rows = CSV.parse(file)

# Via https://stackoverflow.com/questions/29521170/ruby-transpose-csv
puts rows.transpose.map { |x| x.join ',' }
