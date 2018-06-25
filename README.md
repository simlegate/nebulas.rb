# Nebulas

Nebulas is the Nebulas compatible Ruby API. Users can sign/send transactions and deploy/call smart contract with it.

## Requirements

  * Ruby 2.5.1 or higher

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nebulas'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nebulas

## Usage

### Account
  
	require 'nebulas'
	account = Nebulas::Account.new
	addr = account.addr_str # return n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC
	keystore = account.keystore('123456789') # return { version: 3, address: '....', crypto: '.....'}

### Blockchain

	require 'nebulas'
	chain = Nebulas::Blockchain.new
	chain.neb_state
  
### Admin
	
	require 'nebulas'
	# Admin api ONLY connects to localhost
	admin = Nebulas::Admin.new
	admin.node_info

### Address

	require 'nebulas'
	Nebulas::Address.valid?("n1TV3sU6jyzR4rJ1D7jCAmtVGSntJagXZHC")

## Documentation

Generate docs into `doc` directory

    $ bundle exec rake yard

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

You can use the guard tools to watch files change and run tests automatically via running `bundle exec guard`.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nebulas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
