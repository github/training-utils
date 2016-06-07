#!/usr/bin/env ruby
require 'CSV'

rows = CSV.new($stdin).read
puts rows.transpose.map { |x| x.join ',' }
