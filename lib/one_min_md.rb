class OneMinMD
  def initialize(raw_md)
    @raw_md = raw_md
    @md_date = raw_md.md_date
    calculate(@raw_md)
  end

  def calculate(raw_md)
    raw_md_arr = raw_md.getall

    am_start_time = Time.parse(@md_date+'T09:00:00')
    am_stop_time = Time.parse(@md_date+'T11:31:00')
    pm_start_time = Time.parse(@md_date+'T13:00:00')
    pm_stop_time = Time.parse(@md_date+'T15:01:00')

    puts am_start_time, am_stop_time, pm_start_time, pm_stop_time

    @onemin_md_arr = []

    last_price = 0.0 # FIXME: we should to set it to JHJJ price on 09:25:00 or yesterday's last price
    curr_min = am_start_time
    while(curr_min < am_stop_time) do
      next_min = curr_min + 60
      puts next_min

      raw_md_inrange_arr = find_raw_md_inrange(raw_md_arr, curr_min, next_min)
      if raw_md_inrange_arr.empty?
        @onemin_md_arr << [last_price, last_price, last_price, last_price]
      else
        last_price = get_last_price(raw_md_inrange_arr)
        @onemin_md_arr <<
      end

      curr_min = next_min
    end

  end

  # get all one-min K-line info for all day
  def getall
    @onemin_md_arr
  end

  # get the one-min K-line info on 'time'
  def get(time)

  end
end