hattr_accessor
==============

A gem/plugin that allows you to define attr_accessors that reference members of a hash.


Installation
------------

	script/plugin install git://github.com/shuber/proxy.git

OR

	gem install hattr_accessor


Usage
-----

The hattr_accessor method requires an option named :attribute which should be a symbol that represents the attribute name of the hash that you want to reference. For example:

	class SomeClass
	  attr_accessor :my_hash
	  hattr_accessor :my_attr, :attribute => :my_hash
	end
	
	@some_class = SomeClass.new
	@some_class.my_attr = 'test'
	@some_class.my_hash # => { :my_attr => 'test' }

You may optionally pass a :type option which will type cast the value when calling the getter method. For example:

	class SomeClass
	  attr_accessor :my_hash
	  hattr_accessor :birth_day, :birth_year, :type => :integer, :attribute => :my_hash
	end
	
	@some_class.birth_day = '12'
	@some_class.birth_day # => 12
	
	@some_class.birth_year = 2008
	@some_class.birth_year # => 2008

This is useful if you're using this gem/plugin with ActiveRecord which will pass values as strings if submitted from a form. For Example:

	class SomeController < ApplicationController
	  def create
	    @some_class = SomeClass.new(params[:some_class])
	    @some_class.birth_day # => '12'
	    # notice it returns as a string instead of an integer
	    # using :type => :integer will fix this
		end
	end

The current options (email me for suggestions for others) for :type are:

	:string
	:integer
	:float
	:boolean


Example
-------

	class CustomField < ActiveRecord::Base
	  # has a text or blob attribute named :configuration
	  serialize :configuration, {}
	end
	
	class CustomFields::Date < CustomField
	  hattr_accessor :offset, :type => :integer, :attribute => :configuration
	  hattr_accessor :unit, :reference, :attribute => :configuration
		
	  def default_value
	    self.offset.send(self.unit).send(self.reference)
	  end
	end
	
	@field = CustomFields::Date.new({ :offset => '5', :unit => 'days', :reference => 'from_now' })
	@field.configuration # => { :offset => '5', :unit => 'days', :reference => 'from_now' }
	@field.default_value # => evaluates 5.days.from_now


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)