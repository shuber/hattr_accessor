Gem::Specification.new do |s|
  s.name    = 'hattr_accessor'
  s.version = '1.0.2'
  s.date    = '2009-01-08'
  
  s.summary     = 'A gem/plugin that allows you to define attr_accessors that reference members of a hash'
  s.description = 'A gem/plugin that allows you to define attr_accessors that reference members of a hash'
  
  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/hattr_accessor'
  
  s.has_rdoc = false
  
  s.files = %w(
    CHANGELOG
    init.rb
    lib/alias_method_chain.rb
    lib/hattr_accessor.rb
    MIT-LICENSE
    Rakefile
    README.markdown
  )
  
  s.test_files = %w(
    test/hattr_accessor_test.rb
  )
end