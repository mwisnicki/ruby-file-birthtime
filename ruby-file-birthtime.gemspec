Gem::Specification.new do |s|

	s.name = 'file-birthtime'
	s.version = '0.2'
	s.platform = Gem::Platform::RUBY

	s.summary = "Birthtime support for File and File::Stat."

	s.files = Dir.glob("{ext,test}/**/*")
	s.files.concat [ 'COPYING', 'README.rdoc' ]

	s.extensions << 'ext/extconf.rb'
	s.require_paths << 'ext'

	s.has_rdoc = true
	s.extra_rdoc_files = 'README.rdoc'
	s.rdoc_options = [ '--main', 'README.rdoc' ]

	s.test_files = 'test/tests.rb'

	s.author = 'Marcin Wisnicki'
	s.email = 'mwisnicki@gmail.com'

end
