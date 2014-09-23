# ExecSimple

A simple command runner in Ruby.

```ruby
ExecSimple.run 'echo 123'
=> ["123\n", "", 0]
```

```ruby
ExecSimple.run 'echo "error message" >&2; exit 123'
=> ["", "error message\n", 123]
```

Handle timeouts:

```ruby
ExecSimple.run 'echo "Legen... wait for it"; sleep 100; echo "DARY"', timeout: 1
=> ["Legen... wait for it\n", "", nil]
```

Integrate with logging:

```ruby
require 'logging'
log = Logging.logger['main']
log.add_appenders(Logging.appenders.stdout)

ExecSimple.run 'echo "You will read this"; sleep 3; echo "before the end."', log: log
 INFO  main : You will read this
 INFO  main : before the end.
=> 0

```

## Installation

Add this line to your application's Gemfile:

    gem 'exec-simple'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exec-simple



## Contributing

1. Fork it ( http://github.com/arlimus/exec-simple/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## License

MIT
