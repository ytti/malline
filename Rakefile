require 'rake/testtask'

rule '.rb' => '.y' do |t|
  sh "racc -l -o #{t.name} #{t.source}"
end

task :test => :compile do
  Rake::TestTask.new do |t|
    t.libs.push "lib"
    t.test_files = FileList['spec/*_spec.rb']
    t.verbose = true
  end
end

task :compile => 'lib/malline/parser.rb'
