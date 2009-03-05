Gem::Specification.new do |s|
  s.name    = 'hattr_accessor'
  s.version = '1.1.0'
  s.date    = '2009-03-05'
  
  s.summary     = 'Allows you to define attr_accessors that reference members of a hash'
  s.description = 'Allows you to define attr_accessors that reference members of a hash'
  
  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/hattr_accessor'
  
  s.has_rdoc = false
  
  s.files = %w(
    CHANGELOG
    lib/hattr_accessor.rb
    MIT-LICENSE
    Rakefile
    README.markdown
    test/fixtures/manufacturers.yml
    test/fixtures/products.yml
  )
  
  s.test_files = %w(
    test/active_record_test.rb
    test/hattr_accessor_test.rb
  )
end