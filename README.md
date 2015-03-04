## Fluent::Plugin::AddEmptyArray, a plugin for [Fluentd](http://fluentd.org)

Fluentd plugin to add empty array.

## Use case
When using Google Bigquery with schema include "repeated" mode columns and insert record without "repeated" mode columns key, failed insert.
So this plugin support this case according to add such keys complement with "[]".

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-add_empty_array'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-add_empty_array

## Usage

default usage
```
<match test>
  type            add_empty_array
  array_type_key  test3,test4
</match>

input
"test" {
  "test1": "foo",
  "test2": "bar"
}

output
  "add_empty_array.test" {
    "test1": "foo",
    "test2": "bar",
    "test3": [],
    "test4": []
  }
```

change tag prefix (default tag prefix is "add_empty_array.")
```
<match test>
  type            add_empty_array
  array_type_key  test3,test4
  tag_prefix      prefix_test.
</match>

input
"test" {
  "test1": "foo",
  "test2": "bar"
}

output
  "prefix_test.test" {
    "test1": "foo",
    "test2": "bar",
    "test3": [],
    "test4": []
  }
```

## Option Parameters

### array_type_key :keys delimited by commas
array_type_key points to keys which you want complement with "[]" if there are no those keys.
You should set value to array_type_key like this.
Default value is 'nil'.
Require option.

```
array_type_key  foo
```
```
array_type_key  foo,bar,baz
```

If you use this plugin with key include commas, you must use delimiter option like this.
This example, use '.' as delimiter.

```
  type            add_empty_array
  array_type_key  test,3.test,4
  delimiter       .
```

### delimiter :String
Default value is ','.

### tag_prefix :String
Added tag prefix.
Default value is "parsed."

## Change log
See [CHANGELOG.md](https://github.com/h-michael-z/fluent-plugin-add_empty_array/blob/master/CHANGELOG.md) for details.

## Contributing

1. Fork it ( https://github.com/h-michael-z/fluent-plugin-add_empty_array/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
