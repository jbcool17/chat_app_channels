require 'csv'

module App
	class Chat
		attr_accessor :messages

		def initialize
			@file_path = 'static/messages.csv'
			File.file?(@file_path) ? true : create_csv_file

		end

		def create_csv_file
			csv = CSV.open(@file_path, "a+")
			csv << ["date", "user", "message"]
			csv << [Time.now, "STATUS", "Chat has started"]

			csv.close
		end

		def write_to_csv(time, user, message)
			csv = CSV.open(@file_path, "a+")
			# Write to CSV
			csv << [time, user, message]
			csv.close
		end

		# Parse CSV to array of hashes
		def parse_csv
			data = CSV.read(@file_path,  { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})

			data.map { |d| d.to_hash }
		end

	end
end