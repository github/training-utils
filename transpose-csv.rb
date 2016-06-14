#!/usr/bin/env ruby
require 'CSV'

def get_dest(src)
    dest = src.split('.')
    dest[0] += '-transposed'
    dest.join('.')
end

src = ARGV[0]
file = File.open(src, "r:ISO-8859-1")
rows = CSV.parse(file)

CSV.open(get_dest(src), "wb") do |csv|
    rows.transpose.each do |row|
        csv << row
    end
end
