require File.dirname(__FILE__) + '/alias_method_chain'

module Huberry
  module HattrAccessor
    class MissingAttributeError < StandardError; self; end
    
    def hattr_accessor(*attrs)
      options = attrs.last.is_a?(Hash) ? attrs.pop : {}
      
      raise MissingAttributeError, 'Must specify the :attribute option which should be a symbol that references a hash attribute' if options[:attribute].nil?

      attrs.each do |name|
        # Defines a type casting getter method for each attribute
        #
        define_method name do
          value = send(options[:attribute])[name]
          case options[:type]
            when :string
              value.to_s
            when :integer
              value.to_i
            when :float
              value.to_f
            when :boolean
              ![false, nil, 0, '0'].include? value
            else
              value
          end
        end
        
        # Defines a setter method for each attribute
        #
        define_method "#{name}=" do |value|
          send(options[:attribute])[name] = value
        end
      end
      
      # Overwrites the method passed as the :attribute option to ensure that it is a hash by default
      #
      unless instance_methods.include? "#{options[:attribute]}_with_hattr_accessor"
        class_eval <<-EOF
          def #{options[:attribute]}_with_hattr_accessor
            self.#{options[:attribute]} = {} if #{options[:attribute]}_without_hattr_accessor.nil?
            #{options[:attribute]}_without_hattr_accessor
          end
          alias_method_chain :#{options[:attribute]}, :hattr_accessor
        EOF
      end
    end
  end
end

Class.send :include, Huberry::HattrAccessor