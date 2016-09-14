# find way for file to auto close
# if user quits out unexpextedly

class Chat
	attr_accessor :messages

	def initialize
		# if File.file?('messages.txt')
		# 	@messages = open_txt_file
		# else
		# 	@messages = create_txt_file
		# end
		@messages = File.file?('messages.txt') ? open_txt_file : create_txt_file
		
	end

	def create_txt_file
		file = File.new('messages.txt', 'w+')
		file.puts "#{Time.now} - Start of Chat"

		file
	end

	def open_txt_file
		File.open('messages.txt', 'a+')
	end

	def append_to_txt_file(message)
		# adds to txt file
		@messages.puts("#{Time.now} - #{message}")
	end

	def read_file
		# Rewind file to read from beginning
		@messages.rewind
		
		output = File.read(@messages)

		# Move Cursor Back to End of File
		@messages.seek(-2, IO::SEEK_END)

		output
	end

	def generate_csv
		'test'
	end

	def parse_csv
		'test'
	end

	def reset_txt_file
		'test'
	end
end