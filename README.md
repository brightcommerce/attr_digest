[![Gem Version](https://badge.fury.io/rb/attr_digest.svg)](https://badge.fury.io/rb/attr_digest)
[![Build Status](https://travis-ci.org/brightcommerce/attr_digest.svg?branch=master)](https://travis-ci.org/brightcommerce/attr_digest)
[![codecov.io](https://codecov.io/github/brightcommerce/attr_digest/coverage.svg?branch=master)](https://codecov.io/github/brightcommerce/attr_digest?branch=master)
[![HitCount](https://hitt.herokuapp.com/brightcommerce/attr_digest.svg)](https://github.com/brightcommerce/attr_digest)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/brightcommerce/attr_digest/pulls)

# AttrDigest

[**AttrDigest**](https://github.com/brightcommerce/attr_digest) provides functionality to store a hash digest of an attribute using [Argon2](https://github.com/P-H-C/phc-winner-argon2).

Argon2 is a password-hashing function that summarizes the state of the art in the design of memory-hard functions and can be used to hash passwords for credential storage, key derivation, or other applications. It  is the official winner and recommendation of the [Password Hashing Competition (PHC)](https://password-hashing.net) which ran between 2013 and 2015.

This Gem uses the [Ruby Argon2 Gem](https://github.com/technion/ruby-argon2) which provides FFI bindings, and a simplified interface, to the Argon2 algorithm.

**AttrDigest** provides similar functionality to Rails `has_secure_password`, but permits any number attributes to be hashed in a model, and obviously you're not limited to just the `password` attribute.

## Installation

To install add the following line to your `Gemfile`:

``` ruby
gem 'attr_digest'
```

And run `bundle install`.

## Dependencies

Runtime:
- activerecord (>= 4.2.6, ~> 5.0.0)
- activesupport (>= 4.2.6, ~> 5.0.0)
- argon2 (~> 1.1.0)

Development/Test:
- rake (~> 10.5)
- rspec (~> 3.4)
- sqlite3 (~> 1.3)
- simplecov (~> 0.11.2)
- factory_girl (~> 4.5)

## Compatibility

Tested with Ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15] against ActiveRecord 5.0.0 on Mac OS X El Capitan 10.11.5 (15F34).

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

#### Format

You can ensure the attribute you are hashing matches a given regular expression by passing a `format` option:

```ruby
attr_digest :password, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
```

AttrDigest adds the Rails format validator and passes the options hash through as is. See [Active Record Validations format validator](http://edgeguides.rubyonrails.org/active_record_validations.html#format) for options you can pass to the `format` options hash.

**NOTE:** The `format` option is not affected by the `validations` option. Adding the `format` option will add a Rails format validator *regardless* of whether the `validations` option is set to `true` or `false`.

#### Length

You can ensure the attribute your are hashing meets certain length criteria by passing a `length` option:

```ruby
attr_digest :password, length: { minimum: 5 }
attr_digest :password, length: { maximum: 10 }
attr_digest :password, length: { in: 5..10 }
attr_digest :password, length: { is: 8 }
```

AttrDigest adds the Rails length validator and passes the options hash through as is. See [Active Record Validations length validator](http://edgeguides.rubyonrails.org/active_record_validations.html#length) for options you can pass to the `length` options hash.

**NOTE:** The `length` option is not affected by the `validations` option. Adding the `length` option will add a Rails length validator *regardless* of whether the `validations` option is set to `true` or `false`.

### Protected Digest Setter

If you want to prevent the attribute's digest being set directly, you can include the `protected` option:

```ruby
attr_digest :security_answer, protected: true
```

The attribute's digest is *not* protected from direct setting by default.

### Time and Memory Costs

**AttrDigest** sets a default time and memory cost and expects the following minimum and maximum values:

Option | Minimum Value | Maximum Value | Default Value
--- | --- | --- | ---
:time_cost | 1 | 10 | 2
:memory_cost | 1 | 31 | 16

You can change the global defaults by setting the cost options directly on the `AttrDigest` class:

```ruby
AttrDigest.time_cost = 3
AttrDigest.memory_cost = 12
```

You can also change the time and memory cost for a specific attribute by passing the options to the `attr_digest` class method in your model:

```ruby
attr_digest :security_answer, time_cost: 3, memory_cost: 12
```

### Secret Key

Argon2 supports an optional secret key value. This should be stored securely on your server, such as alongside your database credentials. Hashes generated with a secret key will only validate when presented that secret.

You can set the optional secret key globally by setting the `secret` attribute on the `AttrDigest` class:

```ruby
AttrDigest.secret =  Rails.application.secrets.secret_key_base
```

You can also set the optional secret key for a specific attribute by passing the `:secret` option to the `attr_digest` class method in your model:

```ruby
attr_digest :security_answer, secret: Rails.application.secrets.secret_key_base
```

## Tests

Tests are written using Rspec, FactoryGirl and Sqlite3. There are 52 examples with 100% code coverage.

To run the tests, execute the default rake task:

``` bash
bundle exec rake
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credit

I would like to thank [Panayotis Matsinopoulos](http://www.matsinopoulos.gr) for his [has_secure_attribute](https://github.com/pmatsinopoulos/has_secure_attribute) gem which provided a lot of the inspiration and framework for **AttrDigest**.

I would also like to thank [Lawrence Sproul](https://github.com/Lawrence-Sproul) for bringing to light some potential error conditions,  providing the motivation to make the gem feature complete and provide inspiration for additional validation options.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyright

Copyright 2016 Brightcommerce, Inc.
