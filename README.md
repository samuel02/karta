# Karta

Karta is a very light-weight Ruby library that makes it easy to create mapper objects in a Ruby application. The mapper object makes it easy to map or transform one object into an other. The main use case is to transform data objects from an domain to another domain, e.g. map a `Twitter::User` to `User`. Instead of having to, for example, define a method `#from_twitter_user` on the `User` class which sets all attributes correctly a mapper object is created which defines all mappings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'karta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install karta

## Usage

### Setting up a mapper
The main functionality of Karta is used by letting a class extend `Karta::Mapper`. By doing so the class gets `#map` method which will run all methods starting with `map_` on all objects.

##### Example
```ruby
class MyTwitterMapper
  extend Karta::Mapper

  def map_email(twitter_user, user)
    user.email = twitter_user.twitter_email
  end

  def map_username(twitter_user, user)
    user.username = twitter_user.twitter_handle.gsub('@', '')
  end
end

# Mapping from one instance to another, overriding
# values if already set
twitter_user = ...
user = ...
mapped_user = MyTwitterMapper.new.map(from: twitter_user, to: user)

# Mapping from an instance to a class, will return
# a new instance of the class
twitter_user = ...
user = MyTwitterMapper.new.map(from: twitter_user, to: User)

# Using class method (which instantiates before running map on the instance)
twitter_user = ...
user = MyTwitterMapper.map(from: twitter_user, to: User)
```

### Using the mapper registry
To simplify cases when an application has several mappers it is possible to register mappers and then only use `Karta.map` to map between two objects.

##### Example

```ruby
class MyMapper
  extend Karta::Mapper
  # map methods...
end

Karta.register_mapper MyMapper, from_klass: Twitter::User, to_klass: User

# There is an option to not have to specify from and to class
# when registering the mapper. This relies on reflection and
# requires the mapper to have a class name on the correct format
# (`[from class]To[to class]Mapper`) for example `FooToBarMapper`.
class FooToBarMapper
  extend Karta::Mapper
  # map methods
end

# Register mapper with from_klass = Foo and to_klass = Bar
Karta.register_mapper FooToBarMapper

# Using Karta.map to map between two objects
twitter_user = ...
user = Karta.map(from: twitter_user, to: User)

foo = ...
bar = Karta.map(from: foo, to Bar)
```

### One to one mappings
Sometimes you have fields that could be mapped directly without performing any transformations instead of having to define mapping methods for each you can use `one_to_one_mapping :attr`.

##### Example

```ruby
class FooToBarMapper
  extend Karta::Mapper
  one_to_one_mapping :email
end

foo = ...
bar = FooToBarMapper.map(from: foo, to Bar)
puts foo.email == bar.email # => true
```

## Contributing

1. Fork it ( https://github.com/samuel02/karta/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
