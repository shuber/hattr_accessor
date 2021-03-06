require 'bigdecimal'

module Huberry
  module HattrAccessor
    class MissingAttributeError < StandardError; self; end

    def hattr_defined?(attribute)
      hattr_attributes.include?(attribute.to_sym)
    end

    def hattr_attributes
      @hattr_attributes ||= []
    end

    def hattr_accessor(*attrs)
      options = attrs.last.is_a?(Hash) ? attrs.pop : {}

      raise MissingAttributeError, 'Must specify the :attribute option with the name of an attribute which will store the hash' if options[:attribute].nil?

      attrs.each do |name|
        hattr_attributes << name

        # Defines a type casting getter method for each attribute
        #
        define_method name do
          value = send("#{name}_before_type_cast".to_sym)
          return value if options[:allow_nil] && value.nil?
          case options[:type]
            when :string
              value.to_s
            when :symbol
              value.to_s.to_sym
            when :integer
              value.to_i
            when :float
              value.to_f
            when :boolean
              ![false, nil, 0, '0', ''].include?(value)
            when :decimal
              BigDecimal.new(value.to_s)
            when :array
              Array(value)
            else
              value
          end
        end

        # Defines a predicate method for each attribute
        #
        define_method "#{name}?" do
          send(name) ? true : false
        end

        # Defines a setter method for each attribute
        #
        define_method "#{name}=" do |value|
          send(options[:attribute])[name] = value
        end

        # Define a *_before_type_cast method so that we can validate
        #
        define_method "#{name}_before_type_cast" do
          send(options[:attribute]).key?(name) ? send(options[:attribute])[name] : (options[:default].respond_to?(:call) ? options[:default].call(self) : options[:default])
        end
      end

      # Create the reader for #{options[:attribute]} unless it exists already
      #
      attr_reader options[:attribute] unless instance_methods.include?(options[:attribute].to_s)

      # Create the writer for #{options[:attribute]} unless it exists already
      #
      attr_writer options[:attribute] unless instance_methods.include?("#{options[:attribute]}=")

      # Overwrites the method passed as the :attribute option to ensure that it is a hash by default
      #
      unless instance_methods.include?("#{options[:attribute]}_with_hattr_accessor")
        class_eval <<-EOF
          def #{options[:attribute]}_with_hattr_accessor
            self.#{options[:attribute]} = {} if #{options[:attribute]}_without_hattr_accessor.nil?
            #{options[:attribute]}_without_hattr_accessor
          end
          alias_method :#{options[:attribute]}_without_hattr_accessor, :#{options[:attribute]}
          alias_method :#{options[:attribute]}, :#{options[:attribute]}_with_hattr_accessor
        EOF
      end
    end

    module ActiveRecordExtensions
      def self.included(base)
        base.class_eval do

          def read_attribute_with_hattr_accessor(attribute)
            self.class.hattr_defined?(attribute) ? send(attribute) : read_attribute_without_hattr_accessor(attribute)
          end
          alias_method_chain :read_attribute, :hattr_accessor

          def write_attribute_with_hattr_accessor(attribute, value)
            self.class.hattr_defined?(attribute) ? send("#{attribute}=".to_sym, value) : write_attribute_without_hattr_accessor(attribute, value)
          end
          alias_method_chain :write_attribute, :hattr_accessor

          def query_attribute_with_hattr_accessor(attribute)
            self.class.hattr_defined?(attribute) ? send("#{attribute}?".to_sym) : query_attribute_without_hattr_accessor(attribute)
          end
          alias_method_chain :query_attribute, :hattr_accessor

        end
      end
    end
  end
end

Object.send :include, Huberry::HattrAccessor
ActiveRecord::Base.send :include, Huberry::HattrAccessor::ActiveRecordExtensions if Object.const_defined?(:ActiveRecord)