require 'rake/testtask'

rule '.rb' => '.y' do |t|
  sh "racc -l -o #{t.name} #{t.source}"
end
gemspec = eval(File.read(Dir['*.gemspec'].first))
file    = [gemspec.name, gemspec.version].join('-') + '.gem'

desc 'Validate gemspec'
task :gemspec do
  gemspec.validate
end

desc 'Run minitest'
task :test => :compile do
  Rake::TestTask.new do |t|
    t.libs.push "lib"
    all = FileList['spec/*_spec.rb']
    first = %w(spec/lexer_spec.rb spec/handler_spec.rb)
    t.test_files = [first, all-first].flatten
    t.verbose = true
  end
end

desc 'Compile RACC parser'
task :compile => 'lib/malline/parser.rb'

desc 'Build gem'
task :build => [:gemspec, :test] do
  system "gem build #{gemspec.name}.gemspec"
  FileUtils.mkdir_p 'gems'
  FileUtils.mv file, 'gems'
end

desc 'Install gem'
task :install => :build do
  system "sudo sh -c \'umask 022; gem install gems/#{file}\'"
end

desc 'Remove gems'
task :clean do
  FileUtils.rm_rf 'gems'
end

desc 'Push to rubygems'
task :push do
  system "gem push gems/#{file}"
end
