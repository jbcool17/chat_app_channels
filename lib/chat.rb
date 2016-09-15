require 'csv'

module App
	class Chat
		attr_accessor :messages

		def initialize
			@messages = File.file?('messages.csv') ? open_csv_file : create_csv_file
		end

		def create_csv_file
			csv = CSV.open("messages.csv", "a+")
			csv << ["date", "user", "message"]
			csv << [Time.now, "STATUS", "Chat has started"]

			csv
		end

		def open_csv_file
			CSV.open("messages.csv", "a+")
		end

		def write_to_csv(user, message)
			# Seeks end of file
			@messages.seek(-2, IO::SEEK_END)
			# Write to CSV
			@messages << [ Time.now, user, message]
			# Rewind file for display
			@messages.rewind
		end

		# Parse CSV to array of hashes
		def parse_csv
			data = CSV.read(@messages.path,  { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})

			data.map { |d| d.to_hash }
		end

	end
end