!#/usr/bin/env ruby

$:.unshift File.expand_path('../../lib', File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__)

require 'raw_md'
require 'one_min_md'

rawmd = RawMD.new('/home/liuhj/Downloads/sz000669_20141017.xls', '20141017')
oneminmd = OneMinMD.new(rawmd)

onemin_kline_arr = oneminmd.getall

puts onemin_kline_arr