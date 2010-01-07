hattr\_accessor
===============

Allows you to define attr\_accessors that reference members of a hash


Installation
------------

	gem install hattr_accessor


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
	:decimal
	:array

To specify a default value for a member use the `:default` option. For example:

	class DataSource
	  hattr_accessor :adapter, :default => 'mysql', :attribute => :credentials
	  hattr_accessor :username, :default => 'root', :attribute => :credentials
	  hattr_accessor :password, :attribute => :credentials
	end
	
	@data_source = DataSource.new
	@data_source.adapter # 'mysql'

You can also specify a proc for the default value. For example:

	class DataSource
	  hattr_accessor :adapter, :default => 'mysql', :attribute => :credentials
	  hattr_accessor :username, :attribute => :credentials,
	                 :default => lambda { |datasource| Etc.getpwuid(Process.uid).name }
	  hattr_accessor :password, :attribute => :credentials
	end
	
	@data_source = DataSource.new
	@data_source.username # 'process_username'

If you want to take advantage of type casting but also want to return `nil` if a value has not been set then use the `:allow_nil` option. 
By default `:allow_nil` is false for typed members but true for non-typed members. For example:

	class DataSource
	  hattr_accessor :adapter, :type => :string, :allow_nil => true, :attribute => :credentials
	  hattr_accessor :username, :type => :string, :attribute => :credentials
	  hattr_accessor :password, :attribute => :credentials
	end
	
	@data_source = DataSource.new
	@data_source.adapter # nil
	@data_source.username # ''
	@data_source.password # nil

NOTE: Make sure your call `define_attribute_methods` before calling `hattr_accessor` when you're using ActiveRecord and your `:attribute` is a 
database field. The call to `define_attribute_methods` must be after the `serialize` call so that `define_attribute_methods` knows about the 
serialized field.

	class CustomField < ActiveRecord::Base	  
	  serialize :configuration, Hash
	  define_attribute_methods
	  
	  hattr_accessor :testing, :attribute => :configuration
	end


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)