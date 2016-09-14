# find way for file to auto close
# if user quits out unexpextedly

class Chat
	attr_accessor :messages

	def initialize
		@messages = File.file?('messages.txt') ? open_txt_file : create_txt_file
	end

	def create_txt_file
		file = File.new('messages.txt', 'w+')
		file.puts "#{Time.now} - Start of Chat"
		file.rewind

		file
	end

	def open_txt_file
		File.open('messages.txt', 'a+')
	end

	def append_to_txt_file(message)
		# Move Cursor Back to End of File
		@messages.seek(-2, IO::SEEK_END)
		# adds to txt file
		@messages.puts("#{Time.now} - #{message}")
		# Rewind file to read from beginning
		@messages.rewind
	end

	def read_file
		File.read(@messages)
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