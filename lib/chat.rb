require 'csv'

module App
	class Chat
		attr_accessor :messages, :chat_name, :chat_user_list

		def initialize(chat_name)
			@chat_name = chat_name
			@file_path = "static/#{@chat_name}.csv"
			File.file?(@file_path) ? true : create_csv_file
			@chat_user_list = {}
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

		def set_user_color(user)
			current_total = @chat_user_list.count

			@chat_user_list[user] = get_color(current_total)
		end


		def get_color(index)
			colors = ['red', 'green', 'blue', 
					  'purple', 'tomatoe', 
					  'lightblue', 'brown', 'pink']

			colors[index]
		end

	end
end