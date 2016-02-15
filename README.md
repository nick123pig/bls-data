# BlsData

This gem doesn't do much yet. It currently downloads the "SM" series from the United States Bureau of Labor Statistics and transforms the data into a better format for analytics platforms.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bls_data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bls_data

## Usage

```
# Pull SM Data series and transform
require 'bls_data'
BlsData::Client.new.parse_file
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bls_data. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

