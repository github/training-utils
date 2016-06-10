#!/usr/bin/env ruby
require 'CSV'

# Via https://stackoverflow.com/questions/29521170/ruby-transpose-csv
rows = CSV.new($stdin).read
puts rows.transpose.map { |x| x.join ',' }
