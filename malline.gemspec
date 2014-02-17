Gem::Specification.new do |s|
  s.name              = 'malline'
  s.version           = '0.0.1'
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Saku Ytti' ]
  s.email             = %w( saku@ytti.fi )
  s.homepage          = 'https://github.com/ytti/malline'
  s.summary           = 'Templating language targeting IOS/JunOS configs'
  s.description       = 'Mostly like ERB, but <%if foo%> conditional will omit whole line unless code evaluates true'
  s.rubyforge_project = s.name
  s.files             = `git ls-files`.split("\n")
  s.require_path      = 'lib'

  # s.add_dependency 'bundler'

  s.add_development_dependency 'racc'
end

