require 'file_btime'
require 'fileutils'
require 'test/unit'

# assumes that normal filesystems support birthtimes and '/dev' does not
# also assumes that birthtimes have at least 1s precision
class TestFileBirthtime < Test::Unit::TestCase
	UNSUPPORTED_FILE = '/dev/null'
	OK_FILE = '/'
	# XXX maybe in tmp?
	TEST_FILE = ".testfile-#{rand 999}"

	def test_unsupported
		assert File.btime(UNSUPPORTED_FILE).nil?
		assert File.new(UNSUPPORTED_FILE).btime.nil?
		assert File.stat(UNSUPPORTED_FILE).btime.nil?
	end

	def test_supported
		assert not File.btime(OK_FILE).nil?
	end

	def test_equality
		bt1 = File.btime(OK_FILE)
		bt2 = File.new(OK_FILE).btime
		bt3 = File.stat(OK_FILE).btime
		assert not bt1.nil?
		assert bt1 == bt2
		assert bt1 == bt3
	end

	def test_change
		time = Time.now
		assert File.btime(OK_FILE) < time

		sleep 1
		
		FileUtils.touch TEST_FILE
		st1 = File.stat TEST_FILE
		assert st1.btime > time
		assert st1.btime == st1.mtime
		assert st1.btime == st1.ctime

		sleep 1

		FileUtils.touch TEST_FILE
		st2 = File.stat TEST_FILE
		assert st2.btime == st1.btime
		assert st2.btime < st2.mtime

		sleep 1

		File.delete TEST_FILE
		FileUtils.touch TEST_FILE
		st3 = File.stat TEST_FILE
		assert st3.btime > st2.btime
	ensure
		File.delete(TEST_FILE) if File.exists?(TEST_FILE)
	end
end

