!#/usr/bin/env ruby

$:.unshift File.expand_path('../../lib', File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)

require 'raw_md'

rawmd = RawMD.new('./sz000669_20141017.xls', '20141017')

md_arr = rawmd.getall

puts md_arr[0]