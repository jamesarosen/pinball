Small niceties for Ruby and Rails.

For Ruby in general:
	Example usage:
	
	# apply Boolean logic to regular expressions:
	# approximately equal to /[^y]*x[^y]*/
	X_AND_NOT_Y = /x/ & /y/.inverse
	X_AND_Y_AND_EITHER_A_OR_B_BUT_NOT_BOTH = /x/ & /y/ & (/a/ | /b/) & (/a/ & /b/).inverse
	
	# use a StringBuffer:
	buf = StringBuffer.new
	buf << 'foo' << 'bar', << 'baz'
	buf.to_s   # => "foo\nbar\nbaz"

For Rails:
	Acts like a Rails plugin (has init.rb).
	Rails-specific code in lib/tidbits/active_record
	
	Example usage:
	
	# validate that Person has a valid email address
	class Person < ActiveRecord::Base
		validates_presence_of :email
		validates_email							#assumes :email
	end
	
	# validate several email addresses, but only if present:
	class User < ActiveRecord::Base
		validates_email :email, :email2
	end

	# validate that Person has a valid Blog URL
	class Person < ActiveRecord::Base
		validates_presence_of :blog
		validates_uri :blog
	end

	# validate several URLs, if present
	class User < ActiveRecord::Base
		validates_uri :blog, :website
	end