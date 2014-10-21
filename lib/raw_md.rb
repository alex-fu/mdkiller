require 'csv'
require 'time'

class RawMD
  attr_reader :md_date

  def initialize(file, date)
    @md_file = file
    @md_date = date
  end

  def getall
    md_arr = []
    CSV.foreach(File.path(@md_file), {:encoding => 'gb2312', :col_sep => "\t"}) do |col|
      if(col[0] =~ /\d+:\d+:\d+/)
        md_arr << {:time => Time.parse(@md_date+'T'+col[0]), :price => col[1].to_f, :volume => (col[4].to_f/col[1].to_f).to_i, :amount => col[4].to_f}
      end
    end
    md_arr
  end
end