# Cep Calculator
class CepC
  require 'cep_coinbase'

  attr_writer :exchange_values

  def initialize(params={})
    @curr_type   = params.fetch(:currency_type, 'ETH')
    @daily_earn  = params.fetch(:daily_earn, 0.0)
    @pay_limit   = params.fetch(:pay_limit, 1.0)
    @pool_amount = params.fetch(:pool_amount, 0.0)
    @prices      = params.fetch(:prices, {})
    @exchange_values = params.fetch(:exchange_values, [['USD', '$']])

    get_currencies
  rescue
    return -1
  end

  def exchange_diff(curr1,curr2,printable=false)
    diff = price_of(curr1) / price_of(curr2)

    return diff unless printable
    
    diff_str = "#{curr1} / #{curr2}"
    print_header 'CURRENCY(' + diff_str + ')'
    printf "%s currency: %.4f\n", diff_str, diff
    puts

    return diff
  rescue
    return -1
  end 

  def price_of(currency)
    price = @exchanges[currency.upcase]
    (price.nil?) ? raise : price.to_f
  rescue
    puts 'Currency does not exist!'
    # raise
    return -1
  end

  def amount_of(currency,amount,printable=false)
    price = price_of(currency) * amount
    
    return price unless printable

    printf "%s: %.2f %s\n",
              curr, price, curr_sym
    price
  rescue
    false
  end

  def print_exchange_amounts(arr=@exchange_values)
    print_header " #{total_amount} #{@curr_type} EXCHANGE AMOUNTs"

    arr.each { |curr, curr_sym| amount_of(curr, curr_sym, true) }

    true
  rescue
    false
  end

  def print_params
    print_header "PARAMETERS"
    printf "%s: %f\n",'Daily Earn ', @daily_earn
    printf "%s: %f\n",'Pay Limit  ', @pay_limit 
    printf "%s: %f\n",'Pool Amount', @pool_amount
    puts
  end

  def print_owned_amounts(arr=@exchange_values)
    print_header "#{total_amount} #{@curr_type} DETAILED AMOUNTs"

    print_owned_exchange_amounts
    puts

    arr.each do |curr, curr_sym|
      print_owned_amount_of(curr, curr_sym)
      puts
    end

    true
  rescue
    false
  end

  def print_prices(arr=@exchange_values)
    print_header "1 #{@curr_type} PRICEs"
    arr.each do |curr, curr_sym|
      print_price(curr, curr_sym)
    end
    puts

    true
  rescue
    false
  end

  def print_n_day_earned(n = 1, curr_arr = @exchange_values)
    print_header "#{n} DAYs EARNING"
    
    curr_arr.each do |curr, curr_sym|
      print_n_day_earning(n, curr, curr_sym)
    end

    puts
  end

  def print_day_left
    print_header "Mining Estimation"
    if @daily_earn <= 0.0
      puts "Your daily earn is #{@daily_earn}. You will never reached the limit!!!"
      return false
    end

    day_left = (@pay_limit - @pool_amount)/@daily_earn

    if day_left <= 0.0
      printf "%d day left to payout! Please check your wallet.", absolute_day
      return true
    end

    absolute_day = day_left.ceil
    
    complete_perc = (@pool_amount / @pay_limit) * 100
    if complete_perc <= 100.0 && complete_perc > 0.0
      printf "%% %.2f completed!\n", complete_perc
    end

    printf "%d(%.2f) day left to payout!\n", 
            absolute_day, day_left
    puts "Estimated day: #{Date.today+absolute_day}"
    puts

    return true
  rescue
    false
end
  
  private

  def daily_earn(de = false)
    @daily_earn = (de) ? de.to_f : @daily_earn
  end

  def total_amount
    @prices.values.inject(0.0) { |sum, v| sum +v}
  end

  def get_currencies
    exchange_obj    = CEP_COINBASE.new(
      currency_type: @curr_type
    )
    exchange_obj.fetch
    # exchange_obj.cache
    # exchange_obj.rename_param
    exchange_obj.process
    @exchanges = exchange_obj.exchanges

    unless @exchanges
      throw 'Exchanges could not be fetched'
    end
  rescue => e
    throw e
  end

  def print_owned_amount_of(curr, curr_sym='')
    total_price = amount_of(curr, total_amount)

    printf "%s: %.2f: %s\n", 
            curr, total_price, curr_sym

    @prices.each do |name, amount|
      price = amount_of(curr, amount)
      printf "-->%8s: %.2f %s\n", 
                 name, price, curr_sym
    end
  end

  def print_owned_exchange_amounts
    total_price = @prices.values.inject(:+)

    printf "Total: %.8f %s\n",total_price,@curr_type

    @prices.each do |name, amount|
      printf "-->%8s: %.8f %s\n", 
                 name, amount,@curr_type 
  end
  end

  def print_daily_earning(curr, curr_sym='')
    earn = price_of(curr) * @daily_earn
    printf "%s: %.4f %s\n", curr, earn, curr_sym
  end

  def print_n_day_earning(n, curr, curr_sym='')
    earn = n * price_of(curr) * @daily_earn
    printf "%s: %.4f %s\n", curr, earn, curr_sym
  end

  def print_price(curr, curr_sym='')
    printf "%s: %.4f %s\n", curr, price_of(curr), curr_sym
  end

  def print_big_header(str)
   print_head_format str, '='
   puts
  end

  def print_header(str)
   print_head_format str, '-'
   puts
  end

  def print_head_format(str, deli='-')
    len = str.size
    scr_chr_len = 48

    deli_limit = scr_chr_len - len
    deli_limit = (deli_limit > 10) ? (deli_limit/2.0).floor : 5

    deli_limit.times { print deli }
    print '# ' + str + ' #'
    deli_limit.times { print deli }
  end
end
