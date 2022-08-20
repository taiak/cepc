# CEP CALCULATOR COINBASE
CEP Calculator which use CEP class to fetch and process coin prices to print as formated string.

# Usage Example

~~~ruby
require 'cepc_coinbase'

params = {
  currency_type:  'ETH',   # type of currency :)
  daily_earn:     0.1,     # daily earn from mining
  pool_amount:    0.5,     # accumulated and not paid amount which in the pool 
  pay_limit:      1,       # pool pay limit. This value required for day estimation
  prices:         {        # person => amount pairs for total price print 
    'geppetto'    => 0.0000307, # 1 ETH = 1'630.48 USD
    'pinocchio'   => 300,       # ----------
    'collodi'     => 0.00000101 # when 1 ETH = 29'470.7 TRY
    'pool_amount' => 0.5
  },
  exchange_values: [       # this values will be used as print values. 
    ['USD', '$'],          # First param must be in currency list.
    ['TRY', '₺'],          # Second param only used for print money symbol
  ]
}

c = CepC.new(params)

# print 'daily_earn', 'pay_limit' and 'pool_amount' values. This part will be 
# XXX: If pool integration is provided, this part will make more sense.
c.print_params

# calculate TRY/USD value from eth price difference
c.exchange_diff 'TRY', 'USD', true

# print USD-ETH pair
c.exchange_diff 'USD', 'ETH', true

# print the "exchange_values" array value equivalents to the screen
# in this line 1 ETH price will be calculated
c.print_prices

# print the "prices" array value equivalents to the screen
# In this line, the values of the owned eth's will be displayed on the screen.
c.print_owned_amounts

# prints the daily earnings on the screen. 
# if no parameter is given daily gain will be processed
c.print_n_day_earned
c.print_n_day_earned 30

# calculates how many more days it takes to mine to get paid
c.print_day_left
~~~
