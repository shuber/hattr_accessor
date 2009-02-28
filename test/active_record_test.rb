require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require File.dirname(__FILE__) + '/../lib/hattr_accessor'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(:version => 1) do
    create_table :manufacturers do |t|
      t.string :name, :limit => 30, :null => false
    end

    create_table :products do |t|
      t.string :properties, :limit => 255, :null => false
    end
  end
end

class Manufacturer < ActiveRecord::Base
end

class Product < ActiveRecord::Base
  serialize :properties, Hash
  define_attribute_methods

  hattr_accessor :name, :type => :string, :attribute => :properties
  hattr_accessor :manufacturer_id, :type => :integer, :attribute => :properties, :allow_nil => true
  hattr_accessor :colour, :type => :string, :attribute => :properties
  hattr_accessor :weight, :type => :decimal, :attribute => :properties

  belongs_to :manufacturer

  validates_presence_of :name, :manufacturer_id, :colour, :weight
  validates_length_of :name, :maximum => 30
  validates_inclusion_of :colour, :in => %(Red Green Blue)
  validates_numericality_of :weight
end

class ActiveRecordTest < Test::Unit::TestCase

  def setup
    Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures', ActiveRecord::Base.connection.tables)
  end

  def teardown
    Fixtures.reset_cache
  end

  def test_should_fetch_belongs_to_assocation
    assert_equal Manufacturer.find(1), Product.find(1).manufacturer
  end

  def test_should_assign_belongs_to_assocation
    product = Product.find(1)
    manufacturer_1 = Manufacturer.find(1)
    manufacturer_2 = Manufacturer.find(2)
    assert_equal product.manufacturer, manufacturer_1
    product.manufacturer = manufacturer_2
    assert product.save
    product.reload
    assert_equal product.manufacturer, manufacturer_2
  end

  def test_should_pass_validations
    product = Product.find(1)
    manufacturer_3 = Manufacturer.find(3)
    assert product.valid?
    product.name = "Widget D"
    product.manufacturer = manufacturer_3
    product.colour = "Blue"
    product.weight = 10.0
    assert product.valid?
  end

  def test_should_fail_validations
    product = Product.find(1)
    assert product.valid?
    product.name = "This is a very long name that needs to be over 30 characters"
    assert !product.valid?
    assert product.errors.on(:name).include?("too long")
    product.reload
    product.manufacturer_id = nil
    assert !product.valid?
    assert product.errors.on(:manufacturer_id).include?("can't be blank")
    product.reload
    product.colour = "Black"
    assert !product.valid?
    assert product.errors.on(:colour).include?("is not included in the list")
    product.reload
    product.weight = "Not a number"
    assert !product.valid?
    assert product.errors.on(:weight).include?("is not a number")
    product.reload
  end

end