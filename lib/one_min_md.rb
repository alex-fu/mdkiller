class OneMinMD
  def initialize(raw_md)
    @raw_md = raw_md
    @md_date = raw_md.md_date
    calculate(@raw_md)
  end

  private
  def calculate(raw_md)
    raw_md_arr = raw_md.getall

    am_start_time = Time.parse(@md_date+'T09:30:00')
    am_stop_time = Time.parse(@md_date+'T11:31:00')
    pm_start_time = Time.parse(@md_date+'T13:00:00')
    pm_stop_time = Time.parse(@md_date+'T15:01:00')

    puts am_start_time, am_stop_time, pm_start_time, pm_stop_time

    @onemin_md_hash = {}  # contains a bunch of time => [open_price, close_price, high_price, low_price, avg_price, volume, amount]

    last_price = 0.0 # FIXME: we should to set it to JHJJ price on 09:25:00 or yesterday's last price
    ### calculate all k-line in AM
    curr_min = am_start_time
    while(curr_min < am_stop_time) do
      next_min = curr_min + 60

      raw_md_inrange_arr = find_raw_md_inrange(raw_md_arr, curr_min, next_min)
      # puts "raw_md_inrange_arr: #{raw_md_arr}"
      if raw_md_inrange_arr.empty?
        @onemin_md_hash[curr_min] = [last_price, last_price, last_price, last_price, last_price, 0, 0.0]
      else
        last_price = get_last_price(raw_md_inrange_arr)
        @onemin_md_hash[curr_min] = get_kline_data(raw_md_inrange_arr)
      end

      curr_min = next_min
    end

    ### calculate all k-line in AM
    curr_min = pm_start_time
    while(curr_min < pm_stop_time) do
      next_min = curr_min + 60

      raw_md_inrange_arr = find_raw_md_inrange(raw_md_arr, curr_min, next_min)
      # puts "raw_md_inrange_arr: #{raw_md_arr}"
      if raw_md_inrange_arr.empty?
        @onemin_md_hash[curr_min] = [last_price, last_price, last_price, last_price, last_price, 0, 0.0]
      else
        last_price = get_last_price(raw_md_inrange_arr)
        @onemin_md_hash[curr_min] = get_kline_data(raw_md_inrange_arr)
      end

      curr_min = next_min
    end
  end

  def find_raw_md_inrange(raw_md_arr, curr_min, next_min)
    raw_md_inrange_arr = raw_md_arr.select do |raw_md|
      (raw_md[:time] >= curr_min) and (raw_md[:time] < next_min)
    end
    raw_md_inrange_arr
  end

  def get_last_price(raw_md_inrange_arr)
    temp_arr = raw_md_inrange_arr.sort_by { |elem| elem[:time]}
    temp_arr[-1][:price]
  end

  def get_kline_data(raw_md_inrange_arr)
    temp_arr = raw_md_inrange_arr.sort_by { |elem| elem[:time]}
    open_price = temp_arr[0][:price]
    close_price = temp_arr[-1][:price]
    volume = temp_arr.reduce(0) { |vol, md| vol + md[:volume] }
    amount = temp_arr.reduce(0.0) { |amt, md| amt + md[:amount] }
    avg_price = (amount / volume).round(2)
    high_price = temp_arr.max_by { |md| md[:price] }[:price]
    low_price = temp_arr.min_by { |md| md[:price] }[:price]

    [open_price, close_price, high_price, low_price, avg_price, volume, amount]
  end

  public
  # get all one-min K-line info for all day
  def getall
    @onemin_md_hash
  end

  # get the one-min K-line info on 'time'
  def get(time)
    base = Time.parse(@md_date+'T09:30:00')
    t = Time.parse(@md_date+'T'+time)
    @onemin_md_hash[base + ((t-base)/60).to_i*60] #slip to the start of the minute
  end
end