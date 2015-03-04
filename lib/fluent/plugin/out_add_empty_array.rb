module Fluent
  class AddEmptyArrayOutput < Output
  	Fluent::Plugin.register_output('add_empty_array', self)
  	config_param :array_type_key,         :string, :default => nil
    config_param :delimiter,              :string, :default => ','
    config_param :tag_prefix,             :string, :default => 'add_empty_array.'

    def initialize
      super
    end

	  # Define `log` method for v0.10.42 or earlier
    unless method_defined?(:log)
      define_method("log") { $log }
    end

    def configure(conf)
      super

      if @array_type_key
        @array_type_key = @array_type_key.split(@delimiter)
      end

      unless @array_type_key
        raise ConfigError, "'array_type_key' parameter is required on 'fluent-plugin-add_empty_array'"
      end
    end

    def start
      super
    end

    def shutdown
      super
    end

    def emit(tag, es, chain)
      es.each {|time, record|
        t = tag.dup
        new_record = add_empty_array(record)

        t = @tag_prefix + t unless @tag_prefix.nil?

        Engine.emit(t, time, new_record)
      }
      chain.next
    rescue => e
      log.warn("out_add_empty_array: error_class:#{e.class} error_message:#{e.message} tag:#{tag} es:#{es} record:#{record} bactrace:#{e.backtrace.first}")
    end

    def add_empty_array(record)
      @array_type_key.each do |key|
        record[key] = [] unless record.has_key?(key)
      end
      return record
    rescue => e
      log.warn("out_add_empty_array: error_class:#{e.class} error_message:#{e.message} tag:#{tag} record:#{record} bactrace:#{e.backtrace.first}")
    end
  end
end