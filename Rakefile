require 'rake/testtask'

rule '.rb' => '.y' do |t|
  sh "racc -l -o #{t.name} #{t.source}"
end

task :test => :compile do
  Rake::TestTask.new do |t|
    t.libs.push "lib"
    all = FileList['spec/*_spec.rb']
    first = %w(spec/lexer_spec.rb spec/handler_spec.rb)
    t.test_files = [first, all-first].flatten
    t.verbose = true
  end
end

task :compile => 'lib/malline/parser.rb'
