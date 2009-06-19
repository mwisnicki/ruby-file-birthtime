Gem::Specification.new do |s|

	s.name = 'file-birthtime'
	s.version = '0.4'
	s.platform = Gem::Platform::RUBY

	s.summary = "Birthtime support for File and File::Stat."

	#s.files = Dir.glob("{ext,test}/**/*")
	s.files = [
	    'ext/extconf.rb',
	    'ext/file-btime.c',
	    'ext/_doc.rb',
	    'test/tests.rb',
	    'test/test_birthtime.rb'
	]
	s.files.concat [ 'COPYING', 'README.rdoc' ]

	s.extensions << 'ext/extconf.rb'
	s.require_paths << 'ext'

	s.has_rdoc = true
	s.extra_rdoc_files = 'README.rdoc'
	s.rdoc_options = [
	    '--main', 'README.rdoc',
	    '--exclude', 'ext/_doc.rb'
	]

	s.test_files = 'test/tests.rb'

	s.author = 'Marcin Wisnicki'
	s.email = 'mwisnicki@gmail.com'

end
