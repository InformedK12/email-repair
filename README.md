# Email Repair

[![Gem Version](https://badge.fury.io/rb/email_repair.svg)](http://badge.fury.io/rb/email_repair)
[![Build Status](https://travis-ci.org/ChalkSchools/email-repair.svg?branch=master)](https://travis-ci.org/ChalkSchools/email-repair)
[![Coverage Status](https://img.shields.io/coveralls/ChalkSchools/email-repair.svg)](https://coveralls.io/r/ChalkSchools/email-repair?branch=master)

Email Repair is a utility for sanitizing and validating user provided email
address.

## Installation

Add this line to your application's Gemfile:

    gem 'email_repair'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_repair

## Usage

```ruby
require 'email_repair'
require 'ostruct'

EmailRepair::Mechanic.new.repair('blah@gmail')
# "blah@gmail.com"

EmailRepair::Mechanic.new.repair_all(%w[One@@two.com bleep@blop plooooooop])
# <OpenStruct sanitized_emails=["one@two.com"], invalid_emails=["bleep@blop", "plooooooop"]>
```

### Public Methods

#### EmailRepair::Mechanic#repair(email)

Takes a single email address, applies the available repairs to it and returns
the repaired email. If the email cannot be repaired, `nil` is returned instead.

#### EmailRepair::Mechanic#repair_all(emails)

Takes an array of emails, applies available repairs to each email and returns an
`OpenStruct` containing keys `sanitized_emails:` with a unique array of the
emails that were able to be repaired, and `invalid_emails:` with unique array of
the emails that were unable to be repaired

#### EmailRepair::Constants::email_regex

Returns a regular expression to be used to validate user supplied email
addresses.

### Available Repairs

#### CommonMistakeRepair

Repairs common email typos:
* downcases the email
* removes white space
* removes duplicate @ symbols
* replaces `.c0m` with `.com`
* replaces commas with periods

#### CommonDomainSuffixRepair

Adds missing top-level domain for common email domains. For example, it replaces
`blah@gmail` with `blah@gmail.com`.

#### CommonDomainPeriodAdder

Adds missing period between the domain and top-level domain for  common email
domains. For example, it replaces `blah@gmailcom` with `blah@gmail.com`.

#### CommonDomainAtAdder

Replaces '#', '.', or '-', with '@', or adds missing @ symbol for common
domains. For example, it replaces `blahgmail.com` and `blah#gmail.com` with
`blah@gmail.com`.

#### CommonDomainSwapRepair

Fixes swapped letters ('ia' instead of 'ai') in common domains. For example, it
replaces `blah@gmial.com` with `blah@gmail.com`.

#### EmailRegexRepair

Extracts the email address from strings that contain other text. For example, it
replaces `blah <blah@email.com>` with `blah@email.com`.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/email_repair/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
