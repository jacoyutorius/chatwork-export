require "goodbye_chatwork"
require "awesome_print"
require "hashie"
require 'fileutils'

module ChatworkExport
	class Client
		def initialize email, password
			@client = GoodbyeChatwork::Client.new(email, password)
			@client.login
			@log_dir = "./chatwork_logs"
		end
		def export_all_chat
			unless File.exists?(@log_dir)
		    FileUtils.mkdir_p @log_dir
		  end

			rooms =  @client.room_list.map{|r| Hashie::Mash.new({room_id: r[0], room_name:r[1]}) }
			rooms.each do |room|
				@client.export_csv(room.room_id, "#{@log_dir}/#{room.room_name}.csv")
			end
		end
	end
end


if __FILE__ == $0 
	raise "EMail is required!" if ARGV[0].nil?
	raise "Password is required!" if ARGV[1].nil?

	client = ChatworkExport::Client.new(ARGV[0], ARGV[1])
	client.export_all_chat
end