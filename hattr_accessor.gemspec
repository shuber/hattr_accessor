Gem::Specification.new do |s|
  s.name    = 'hattr_accessor'
  s.version = '1.0.4'
  s.date    = '2009-01-12'
  
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
  )
  
  s.test_files = %w(
    test/hattr_accessor_test.rb
  )
end