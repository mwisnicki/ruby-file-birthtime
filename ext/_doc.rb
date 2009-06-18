# This file is a workaround for a lack of C parser in yardoc

#
class File < IO
    # Returns the creation time as an object of class <code>Time</code>
    # for <i>file</i> or <code>nil</code> if it is not available.
    #
    #   File.new("testfile").btime   #=> Wed Dec 31 18:00:00 CST 1969
    #
    def btime
	native_code
    end
    
    # Returns the creation time for the named file as an object of class
    # <code>Time</code> or <code>nil</code> if it is not available.
    #
    #   File.btime("testfile")   #=> Wed Apr 09 08:51:48 CDT 2003
    #
    def File.btime(file_name)
	native_code
    end
    
    class Stat
	# Returns the creation time for this file as an object of class
	# <code>Time</code> or <code>nil</code> if it is not available.
	#
	#   File.stat("testfile").btime   #=> Wed Dec 31 18:00:00 CST 1969
	#
	def btime
	    native_code
	end
    end
end
