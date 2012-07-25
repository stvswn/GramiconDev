require 'rake'
extend ActionView::Helpers

namespace :grams do
	task :expire_claim => :environment do
		t = Message.arel_table
		Message.where(t[:state].eq('sent').or(t[:state].eq('held'))).each { |message| 
			message.expire if message.claim_expired? 
		}
	end

	task :downrate_unreplied => :environment do
		t = Message.arel_table
		Message.where(t[:state].eq('opened').and(t[:type].eq('Message'))).each { |message| 
			if !message.replied_to? && message.reply_expired? && message.interaction_id && !message.rating
				message.interaction.rating = Rating.create(
							:value => false,
							:user_id => message.recipient_id,
							:interaction_id => message.interaction.id )
			end
		}
	end
end

namespace :seeddata do
	task :inbox, [:user_id] => :environment do |_, args|
		puts "args: #{args} | userid: #{args[:user_id]}"
		2.times do
			@message = produce_message(args[:user_id])
			# @message.created_at = Time.now - 1000000.seconds + 60.seconds
			@message.save!
		  	@message.send_off
	  		puts @message, @message.valid?
	    end
	end
end

def pick(model_class)
	offset = rand(model_class.count)
	model_class.find(:first, :offset => offset)
end

def produce_message(user_id)
	message = Message.new
	message.recipient_id = user_id
	message.sender_id = pick(User).id
	message.credits = 7
	message.body = "Seed Data | Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
	tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
	quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
	consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
	cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
	proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
	message
end


# task :my_task, :arg1, :arg2 do |t, args|
#   puts "Args were: #{args}"
# end

