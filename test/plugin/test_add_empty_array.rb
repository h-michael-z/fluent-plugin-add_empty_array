require 'helper'
require 'pry-byebug'
require 'timecop'
require 'fluent/plugin/out_add_empty_array'

class AddEmptyArrayOutputTest < Test::Unit::TestCase

  TEST_RECORD = {
    "abc" => "edf",
    "123" => "456"
  }

  def setup
    Fluent::Test.setup
    Timecop.freeze(@time)
  end

  def create_driver(conf, tag)
    Fluent::Test::OutputTestDriver.new(
      Fluent::AddEmptyArrayOutput, tag
    ).configure(conf)
  end

  def emit(conf, record, tag='test')
    d = create_driver(conf, tag)
    d.run {d.emit(record)}
    emits = d.emits
  end

  def test_configure_default_tag_prefix
    d = create_driver(%[array_type_key  a,b,c,1,2,3], "test")
    assert_equal ["a", "b", "c" , "1" , "2" , "3"],  d.instance.array_type_key
    assert_equal 'add_empty_array.',                 d.instance.tag_prefix
  end

  def test_configure_array_type_key_eq_nil
    assert_raise(Fluent::ConfigError) do
      create_driver(%[], "test")
    end
  end

  def test_configure
    d = create_driver(%[
      array_type_key  a.b.c.1.2.3
      delimiter       .
      tag_prefix      michael.
    ], "test")

    assert_equal ["a", "b", "c" , "1" , "2" , "3"],  d.instance.array_type_key
    assert_equal '.',                                  d.instance.delimiter
    assert_equal 'michael.',                         d.instance.tag_prefix
  end

  def test_add_empty_array
    conf = %[
      array_type_key  test_array
    ]

    record = TEST_RECORD

    emits = emit(conf, record)

    emits.each_with_index do |(tag, time, record), i|
      assert_equal 'add_empty_array.test',                     tag
      assert_equal 'edf',                                  record['abc']
      assert_equal '456',                                       record['123']
      assert_equal [],                              record['test_array']
    end
  end

  def test_add_empty_array_with_multiple_keys
    conf = %[
      array_type_key  test_array1,test_array2,test_array3
    ]

    record = TEST_RECORD

    emits = emit(conf, record)

    emits.each_with_index do |(tag, time, record), i|
      assert_equal 'add_empty_array.test',                     tag
      assert_equal 'edf',                                  record['abc']
      assert_equal '456',                                       record['123']
      assert_equal [],                              record['test_array1']
      assert_equal [],                              record['test_array2']
      assert_equal [],                              record['test_array3']
    end
  end

  def test_add_empty_array_with_delimiter
    conf = %[
      array_type_key  test_array1.test_array2.test_array3
      delimiter       .
    ]

    record = TEST_RECORD

    emits = emit(conf, record)

    emits.each_with_index do |(tag, time, record), i|
      assert_equal 'add_empty_array.test',                     tag
      assert_equal 'edf',                                  record['abc']
      assert_equal '456',                                       record['123']
      assert_equal [],                              record['test_array1']
      assert_equal [],                              record['test_array2']
      assert_equal [],                              record['test_array3']
    end
  end
end