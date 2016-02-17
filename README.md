[![Gem Version](https://badge.fury.io/rb/attr_digest.svg)](https://badge.fury.io/rb/attr_digest)
[![Build Status](https://travis-ci.org/brightcommerce/attr_digest.svg?branch=rails5)](https://travis-ci.org/brightcommerce/attr_digest)
[![codecov.io](https://codecov.io/github/brightcommerce/attr_digest/coverage.svg?branch=rails5)](https://codecov.io/github/brightcommerce/attr_digest?branch=master)
[![HitCount](https://hitt.herokuapp.com/brightcommerce/attr_digest.svg)](https://github.com/brightcommerce/attr_digest)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/dwyl/esta/issues)

# AttrDigest

[**AttrDigest**](https://github.com/brightcommerce/attr_digest) provides functionality to store a hash digest of an attribute using [Argon2](https://github.com/P-H-C/phc-winner-argon2).

Argon2 is a password-hashing function that summarizes the state of the art in the design of memory-hard functions and can be used to hash passwords for credential storage, key derivation, or other applications. It  is the official winner and recommendation of the [Password Hashing Competition (PHC)](https://password-hashing.net) which ran between 2013 and 2015.

This Gem uses the [Ruby Argon2 Gem](https://github.com/technion/ruby-argon2) which provides FFI bindings, and a simplified interface, to the Argon2 algorithm.

**AttrDigest** provides similar functionality to Rails `has_secure_password`, but permits any number attributes to be hashed in a model, and obviously you're not limited to just the `password` attribute. 

## Installation

To install add the following line to your `Gemfile`:

``` ruby
gem 'attr_digest', '~> 1.0'
```

And run `bundle install`.

## Dependencies

Runtime:
- activerecord (~> 4.2.5.1)
- activesupport (~> 4.2.5.1)
- argon2 (~> 0.1.4)

Development/Test:
- rake (~> 10.5)
- rspec (~> 3.4)
- sqlite3 (~> 1.3)
- simplecov (~> 0.11.2)
- factory_girl (~> 4.5)

## Compatibility

Tested with Ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-darwin15] against ActiveRecord 4.2.5.1 on Mac OS X El Capitan 10.11.3 (15D21).

Argon2 requires Ruby 2.2 minimum and an OS platform that supports Ruby FFI Bindings, so unfortunately Windows is out.


## Usage

Attributes to be digested are declared using the `attr_digest` class method in your model:

```ruby
ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :security_question, null: false
    t.string :security_answer_digest, null: false
  end
end

class User < ActiveRecord::Base
  attr_digest :security_answer
end
```

**AttrDigest** automatically creates the `#security_answer` getter and `#security_answer=` setter. The setter creates a digest of the value provided and stores it in the `security_answer_digest` column.

**AttrDigest** also defines the method `authenticate_security_answer(value)` which returns `false` if the `value` given does not correspond to the saved digest, or returns `true` if it does.

### Validations

**AttrDigest** adds some default validations. Using the example above:
* it creates a `confirmation` validation on `security_answer`, but only if `security_answer` is given (for confirmation validations see [ActiveRecord Validations](http://http://guides.rubyonrails.org/active_record_validations.html#confirmation)).
* it creates a `presence` validation on `security_answer` but only on `create`.
* it creates a `presence` validation on `security_answer_confirmation` but only if `security_answer` has been given; and
* it raises an `exception` if `security_answer_digest` is empty on `create`.

You can disable all validations by passing `false` to the `validations` option:

```ruby
attr_digest :security_answer, validations: false
```

#### Case Sensitivity

If you want values passed to be case insensitive, you can pass `false` to the `case_sensitive` option:

```ruby
attr_digest :security_answer, case_sensitive: false
```

Then differing cases will match, e.g. `pizza` will match `PizzA`.

#### Confirmations

If you prefer to skip confirmations for the attribute you are hashing, you can pass `false` to the `confirmation` option:

```ruby
attr_digest :security_answer, confirmation: false
```

#### Protected Digest Setter

If you want to prevent the attribute's digest being set directly, you can include the `protected` option:

```ruby
attr_digest :security_answer, protected: true
```

The attribute's digest is *not* protected from direct setting by default.

## Tests

Tests are written using Rspec, FactoryGirl and Sqlite3. There are 31 examples with 100% code coverage.

To run the tests, execute the default rake task:

``` bash
bundle exec rake
```

## Roadmap

I would like to add the ability to pass a `secret` to the Argon2 hasher. This functionality exists in the Ruby Argon2 Gem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credit

I would like to thank [Panayotis Matsinopoulos](http://www.matsinopoulos.gr) for his [has_secure_attribute](https://github.com/pmatsinopoulos/has_secure_attribute) gem which provided a lot of the inspiration and framework for **AttrDigest**.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright 2016 Brightcommerce, Inc.