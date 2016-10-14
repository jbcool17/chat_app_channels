require 'csv'

module App
	class Chat
		attr_accessor :messages, :chat_name, :chat_user_list

		def initialize(chat_name)
			@chat_name = chat_name
			@file_path = "static/#{@chat_name}.csv"
			File.file?(@file_path) ? true : create_csv_file
			@colors = ["#D3D3D3"]
			@chat_user_list = {}
		end

		def create_csv_file
			csv = CSV.open(@file_path, "a+")
			csv << ["date", "user", "message", "color"]
			csv << [Time.now, "STATUS", "Chat has started", "#D3D3D3"]

			csv.close
		end

		def write_to_csv(time, user, message, color)
			csv = CSV.open(@file_path, "a+")
			# Write to CSV
			csv << [time, user, message, color]
			csv.close
		end

		# Parse CSV to array of hashes
		def parse_csv
			data = CSV.read(@file_path,  { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})

			data.map { |d| d.to_hash }
		end

		def set_user_color(user)
			@chat_user_list[user] = get_color
		end


		def get_color

			color = "#%06x" % (rand * 0xffffff)

			if (@colors.include?(color))
				color = "#%06x" % (rand * 0xffffff)
			end

			color
		end

	end
end