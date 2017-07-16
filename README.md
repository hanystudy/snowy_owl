# SnowyOwl

Owl exploratory testing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snowy_owl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snowy_owl

## Usage

Make sure you have directory structure like below:

```markdown
your_test_directory/
├── props/
├── determinations/
├── plots/
├── play_books/
└── play.rb
```

Add this line to play.rb:

```ruby
require 'snowy_owl'

SnowyOwl.play
```

### Used with RSpec

Add this to spec_helper.rb:

```ruby
require 'snowy_owl'
require 'snowy_owl/rspec'
```

Use play_spec.rb instead of play.rb, and add this line to play_spec.rb:

```ruby
require 'spec_helper'

SnowyOwl.play
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hanystudy/snowy_owl. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SnowyOwl project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hanystudy/snowy_owl/blob/master/CODE_OF_CONDUCT.md).