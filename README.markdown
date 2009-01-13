hattr\_accessor
===============

Allows you to define attr\_accessors that reference members of a hash


Installation
------------

	gem install shuber-hattr_accessor --source http://gems.github.com


Usage
-----

The hattr\_accessor method requires an option named `:attribute` which should be name of an attribute which will store the hash. For example:

	class DataSource
	  hattr_accessor :adapter, :username, :password, :attribute => :credentials
	end

The reader and writer methods for `:attribute` (`:credentials` in the example above) would be automatically created unless they exist already. 
You can then use those attributes like normal ones:

	@data_source = DataSource.new
	@data_source.adapter = 'mysql'
	@data_source.username = 'root'
	@data_source.credentials # { :adapter => 'mysql', :username => 'root' }
	
	@data_source.credentials = {}
	@data_source.adapter # nil

The reader method for `:attribute` is overwritten with logic to ensure that it returns a hash by default.

	@data_source = DataSource.new
	@data_source.credentials # {}

You may optionally pass a `:type` option which will type cast the values when calling their getter methods. This is useful if you're using this 
gem with rails which will pass values as strings if submitted from a form. For example:

	class CustomField::Date < CustomField
	  hattr_accessor :offset, :type => :integer, :attribute => :configuration
	  hattr_accessor :unit, :reference, :type => :string, :attribute => :configuration
	  
	  def default_value
	    self.offset.send(self.unit.to_sym).send(self.reference.to_sym)
	  end
	end
	
	@custom_field = CustomField::Date.new(:offset => '5', :unit => 'days', :reference => 'from_now')
	@custom_field.offset # 5 (notice it's an integer, not a string)
	@custom_field.default_value # evaluates 5.days.from_now 

The current options (email me for suggestions for others) for `:type` are:

	:string
	:integer
	:float
	:boolean

NOTE: Make sure your call `define_attribute_methods` before calling `hattr_accessor` when you're using ActiveRecord and your `:attribute` is a 
database field.

	class CustomField < ActiveRecord::Base
	  define_attribute_methods
	  
	  serialize :configuration, Hash
	  
	  hattr_accessor :testing, :attribute => :configuration
	end


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)